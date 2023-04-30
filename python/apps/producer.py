from confluent_kafka import Producer
import random
import time
import json

# Kafka topic to send messages to
topic = "mytopic"

# Kafka broker URL
bootstrap_servers = "broker:29092"

# Create a Kafka producer instance
producer = Producer({"bootstrap.servers": bootstrap_servers})

# Generate 10000 messages with random temperatures between 18 and 30
for i in range(10000):
    # Construct message payload
    message = {
        "id": i,
        "temperature": random.randint(18, 30)
    }

    # Send message to Kafka topic with key and value
    key = str(1)
    data = json.dumps(message)
    try:
        producer.produce(topic, value=data)
        #producer.produce(topic, key=key, value=data)
        print(f"Sent message {i}: {message}")
    except Exception as e:
        print(f"Error sending message: {e}")

    # Wait for a short time before sending the next message
    time.sleep(0.2)

    # Wait for any outstanding messages to be delivered and delivery reports to be received
    producer.flush()