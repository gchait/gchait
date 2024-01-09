"""
Some functions to make ECS easier to use.
"""

import json
import uuid
import construct as c
import websocket


def ecs_execute_command(ecs_client, cluster: str, task: str, command: str) -> str:
    """Executes a bash command/script inside an ECS task and returns the output"""
    exec_resp = ecs_client.execute_command(
        interactive=True, cluster=cluster, task=task, command=f"bash -c '{command}'"
    )

    session = exec_resp["session"]
    connection = websocket.create_connection(session["streamUrl"])

    try:
        connection.send(
            json.dumps(
                {
                    "MessageSchemaVersion": "1.0",
                    "RequestId": str(uuid.uuid4()),
                    "TokenValue": session["tokenValue"],
                }
            )
        )

        agent_message_header = c.Struct(
            "HeaderLength" / c.Int32ub,
            "MessageType" / c.PaddedString(32, "ascii"),
        )

        agent_message_payload = c.Struct(
            "PayloadLength" / c.Int32ub,
            "Payload" / c.PaddedString(c.this.PayloadLength, "ascii"),
        )

        while True:
            response = connection.recv()
            message = agent_message_header.parse(response)

            if "channel_closed" in message.MessageType:
                raise Exception("Channel closed before command output was received")

            if "output_stream_data" in message.MessageType:
                break

    finally:
        connection.close()

    return agent_message_payload.parse(response[message.HeaderLength :]).Payload
