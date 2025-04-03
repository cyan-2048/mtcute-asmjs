#include "wasm.h"
#include "libwebp/src/webp/decode.h"
#include "libwebp/src/webp/demux.h"

int width, height;

WASM_EXPORT uint8_t* webp_decode(const uint8_t *data, size_t databytes) {
  return WebPDecodeRGBA(data, databytes, &width, &height);
};

WASM_EXPORT int webp_getWidth() {
  return width;
}

WASM_EXPORT int webp_getHeight() {
  return height;
}

WASM_EXPORT void webp_free(void *pointer) {
  WebPFree(pointer);
}

WASM_EXPORT uint8_t* testNull() {
  return NULL;
}