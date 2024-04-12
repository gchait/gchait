def hello(caller):
    print(f"Hello from {caller}!")


def delivery_callback(err, msg):
    # Optional per-message delivery callback (triggered by poll() or flush())
    # when a message has been successfully delivered or permanently
    # failed delivery (after retries).
    if err:
        print("ERROR: Message failed delivery: {}".format(err))
    else:
        print("Produced event to topic {topic}: key = {key:12} value = {value:12}".format(
            topic=msg.topic(), key=msg.key().decode("utf-8"), value=msg.value().decode("utf-8")))


def reset_offset(consumer, partitions):
    # Set up a callback to handle the "--reset" flag.
    from confluent_kafka import OFFSET_BEGINNING
    for p in partitions:
        p.offset = OFFSET_BEGINNING
    consumer.assign(partitions)


def sleep_forever():
    from time import sleep
    while True:
        sleep(1)


#!/usr/bin/env python3

import common as utils
from random import choice
from confluent_kafka import Producer

if __name__ == "__main__":
    utils.hello("xx-yy")

    # Create Producer instance
    config = {
        "bootstrap.servers": "broker:29092"
    }
    producer = Producer(config)

    # Produce data by selecting random values from these lists.
    topic = "purchases"
    user_ids = ["eabara", "jsmith", "sgarcia", "jbernard", "htanaka", "awalther"]
    products = ["book", "alarm clock", "t-shirts", "gift card", "batteries"]

    for _ in range(100):
        user_id = choice(user_ids)
        product = choice(products)
        producer.produce(topic, product, user_id, callback=utils.delivery_callback)

    # Block until the messages are sent.
    producer.poll(10000)
    producer.flush()

    # Stay alive
    utils.sleep_forever()


#!/usr/bin/env python3

import common as utils
from confluent_kafka import Consumer


if __name__ == "__main__":
    utils.hello("xx-zz")

    # Create Consumer instance
    config = {
        "bootstrap.servers": "broker:29092",
        "group.id": "xx_zz",
        "auto.offset.reset": "earliest"
    }
    consumer = Consumer(config)

    # Subscribe to topic
    topic = "purchases"
    consumer.subscribe([topic], on_assign=utils.reset_offset)

    # Poll for new messages from Kafka and print them.
    try:
        while True:
            msg = consumer.poll(1.0)

            if msg is None:
                # Initial message consumption may take up to
                # `session.timeout.ms` for the consumer group to
                # rebalance and start consuming
                print("Waiting...")

            elif msg.error():
                print("ERROR: %s".format(msg.error()))

            else:
                # Extract the (optional) key and value, and print.
                print("Consumed event from topic {topic}: key = {key:12} value = {value:12}".format(
                    topic=msg.topic(), key=msg.key().decode("utf-8"), value=msg.value().decode("utf-8")))

    except KeyboardInterrupt:
        pass

    finally:
        # Leave group and commit final offsets
        consumer.close()

    # Stay alive
    utils.sleep_forever()
