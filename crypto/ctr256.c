#include "aes256.h"

struct ctr256_ctx {
    uint32_t expandedKey[EXPANDED_KEY_SIZE];
    uint8_t iv[AES_BLOCK_SIZE];
    uint8_t state;
};

WASM_EXPORT struct ctr256_ctx* ctr256_alloc() {
    struct ctr256_ctx *state = (struct ctr256_ctx *)malloc(sizeof(struct ctr256_ctx));
    aes256_set_encryption_key(aes_shared_key_buffer, state->expandedKey);

    memcpy(state->iv, aes_shared_iv_buffer, AES_BLOCK_SIZE);
    state->state = 0;

    return state;
}

WASM_EXPORT void ctr256_free(struct ctr256_ctx* ctx) {
    free(ctx);
}

WASM_EXPORT void ctr256(struct ctr256_ctx* ctx, uint8_t* in, uint32_t length, uint8_t *out) {
    uint8_t chunk[AES_BLOCK_SIZE];
    uint32_t* expandedKey = ctx->expandedKey;
    uint8_t* iv = ctx->iv;
    uint8_t state = ctx->state;
    uint32_t i, j, k;

    aes256_encrypt(iv, chunk, expandedKey);

    for (i = 0; i < length; i += AES_BLOCK_SIZE) {
        for (j = 0; j < MIN(length - i, AES_BLOCK_SIZE); ++j) {
            out[i + j] = in[i + j] ^ chunk[state++];

            if (state >= AES_BLOCK_SIZE)
                state = 0;

            if (state == 0) {
                k = AES_BLOCK_SIZE;
                while(k--)
                    if (++iv[k])
                        break;

                aes256_encrypt(iv, chunk, expandedKey);
            }
        }
    }

    free(in);

    ctx->state = state;
}