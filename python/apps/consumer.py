from confluent_kafka import Consumer, KafkaError
import time
import argparse

parser = argparse.ArgumentParser()
parser.add_argument('--group_id', default='random', help='group.id for the consumer')
args = parser.parse_args()

if args.group_id == 'random':
    import uuid
    args.group_id = str(uuid.uuid4())

print(f"Consuming from consumer group: {args.group_id}")

# Kafka topic to consume messages from
topic = "mytopic"

# Kafka broker URL
bootstrap_servers = "broker:29092"

# Create a Kafka consumer instance
consumer = Consumer({
    "bootstrap.servers": bootstrap_servers,
    "group.id": args.group_id,
    "auto.offset.reset": "latest"
})
consumer.subscribe([topic])

# Continuously poll for messages
while True:
    message = consumer.poll(timeout=1.0)

    if message is None:
        continue
    if message.error():
        if message.error().code() == KafkaError._PARTITION_EOF:
            print(f"Reached end of partition for {message.topic()}[{message.partition()}]")
        else:
            print(f"Error while consuming message: {message.error()}")
    else:
        # Extract message payload
        message_payload = message.value().decode("utf-8")
        kafka_timestamp = message.timestamp()[1]

        # Print message contents and timestamp
        print(f"Received message: {message_payload}, timestamp: {kafka_timestamp}")
# Close the consumer when finished
consumer.close()