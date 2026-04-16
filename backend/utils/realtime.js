const { EventEmitter } = require("events");

const realtimeEmitter = new EventEmitter();

const publishEvent = (eventType, payload) => {
  realtimeEmitter.emit("event", {
    eventType,
    payload,
    timestamp: new Date().toISOString(),
  });
};

module.exports = {
  realtimeEmitter,
  publishEvent,
};
