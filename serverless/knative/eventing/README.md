# [Knative Eventing][knative-eventing-doc]

## Késako ?

Knative Eventing is a collection of APIs that enable you to use an event-driven architecture with your applications. You can use these APIs to create components that route events from event producers (known as sources) to event consumers (known as sinks) that receive events. ***Sinks can also be configured to respond to HTTP requests by sending a response event.***
Knative Eventing uses ***standard HTTP POST requests to send and receive events between event producers and sinks***. These events conform to the [CloudEvents specifications][cloudevents-specifications], which enables creating, parsing, sending, and receiving events in any programming language.

## Install

## Test

## Uninstall

<!-- Links -->
[knative-eventing-doc]: https://knative.dev/docs/eventing/
[cloudevents-specifications]: https://cloudevents.io/