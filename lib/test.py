import cv2  # For getting video frames
import uvicorn  # ASGI server to run FastAPI
from fastapi import FastAPI, WebSocket, WebSocketDisconnect # FastAPI for web server, WebSocket for connections
from starlette.websockets import WebSocketState # To check client connection status
import asyncio # For running tasks concurrently (like getting video and sending it)
# import base64 # Not used in the primary byte sending method, but an alternative

# --- ESP32 Stream Configuration ---
ESP32_STREAM_URL = 'http://<ESP32_LOCAL_IP_ADDRESS>:80/' # URL of your ESP32's MJPEG stream

app = FastAPI() # Initialize our web application server

# This class helps manage all connected Flutter apps (WebSocket clients)
class ConnectionManager:
    def __init__(self):
        self.active_connections: list[WebSocket] = [] # A list to store active WebSocket connections

    async def connect(self, websocket: WebSocket):
        await websocket.accept() # Accept a new WebSocket connection from a client
        self.active_connections.append(websocket) # Add it to our list of active connections

    def disconnect(self, websocket: WebSocket):
        if websocket in self.active_connections:
            self.active_connections.remove(websocket) # Remove from list if client disconnects

    async def broadcast_bytes(self, data: bytes):
        # Send data (our image bytes) to ALL currently connected clients
        for connection in self.active_connections:
            if connection.client_state == WebSocketState.CONNECTED: # Check if client is still connected
                try:
                    await connection.send_bytes(data) # Send the raw bytes
                except Exception as e:
                    print(f"Error sending to a client, removing: {e}")
                    # If error sending, assume client is gone and remove them
                    self.active_connections.remove(connection)


manager = ConnectionManager() # Create an instance of our connection manager

# This is the main function that gets video from ESP32 and sends it out
async def stream_video_to_clients():
    """Grabs frames from ESP32 and broadcasts them via WebSocket."""
    cap = cv2.VideoCapture(ESP32_STREAM_URL) # Try to open the ESP32's MJPEG video stream
    if not cap.isOpened():
        print(f"Error: Could not open video stream at {ESP32_STREAM_URL}")
        # In real code, you'd have more robust retry logic here
        return

    while True: # Loop forever to keep streaming
        ret, frame = cap.read() # Read one frame from the ESP32 stream
        if not ret:
            print("Error fetching frame. Retrying stream connection...")
            cap.release() # Release the old connection
            await asyncio.sleep(1) # Wait a second
            cap = cv2.VideoCapture(ESP32_STREAM_URL) # Try to reconnect
            if not cap.isOpened():
                print("Failed to reconnect to stream.")
                await asyncio.sleep(1) # Wait before trying the loop again
                continue # Skip the rest of this loop iteration
            ret, frame = cap.read() # Try reading again
            if not ret:
                continue


        # We need to send JPEG images. ESP32 usually sends JPEGs in MJPEG.
        # If 'frame' wasn't JPEG, you'd encode it. But here we assume it's decodable by OpenCV
        # and we re-encode to control quality and ensure it's JPEG bytes.
        ret_encode, buffer = cv2.imencode('.jpg', frame, [cv2.IMWRITE_JPEG_QUALITY, 70]) # Encode the frame as JPEG bytes
        if not ret_encode:
            print("Error encoding frame to JPEG")
            continue # Skip this frame

        frame_bytes = buffer.tobytes() # Get the raw bytes of the JPEG image

        # --- Your YOLO detection logic could go here using 'frame' ---
        # if person_detected_by_yolo:
        #   record_frame(frame_bytes)
        #   send_alert_or_metadata_over_websocket()

        # Only broadcast if there are actual clients connected
        if manager.active_connections:
            await manager.broadcast_bytes(frame_bytes) # Send the current frame to all connected clients

        # Control the frame rate. Adjust sleep time for more/less FPS.
        # e.g., 0.03s = ~33 FPS. 0.066s = ~15FPS
        await asyncio.sleep(0.04) # Roughly 25 FPS, adjust as needed for ESP32's actual output rate

    cap.release() # Release the video capture when loop ends (though this loop is infinite)

# This defines the WebSocket URL that Flutter apps will connect to
@app.websocket("/api/video_socket")
async def websocket_endpoint(websocket: WebSocket):
    await manager.connect(websocket) # When a new Flutter app connects, accept and add to manager
    print(f"Client connected: {websocket.client}")
    try:
        # Keep this connection alive.
        # You could also have the client send messages to the server here if needed.
        while True:
            # This part just keeps the connection open from the server side.
            # If the client sends a message, it would be received here.
            await websocket.receive_text() # Example: wait for any message from client
            # Or simply `await asyncio.sleep(1)` if no client messages are expected here
            # but you want to keep the connection handler alive to detect disconnects.
    except WebSocketDisconnect:
        manager.disconnect(websocket)
        print(f"Client disconnected: {websocket.client}")
    except Exception as e:
        # Catch other potential errors with this specific client connection
        print(f"Exception with client {websocket.client}: {e}")
        if websocket in manager.active_connections: # Ensure it's still there before removing
             manager.disconnect(websocket)


# This tells FastAPI to start the `stream_video_to_clients` function
# when the server application starts up. It runs in the background.
@app.on_event("startup")
async def startup_event():
    asyncio.create_task(stream_video_to_clients()) # Schedule the video streaming task
    print("Video streaming background task started.")
