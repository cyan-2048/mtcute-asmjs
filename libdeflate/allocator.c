#include "wasm.h"

WASM_EXPORT void *libdeflate_aligned_malloc(size_t alignment, size_t size)
{
    void *ptr = malloc(sizeof(void *) + alignment - 1 + size);

    if (ptr) {
        void *orig_ptr = ptr;

        ptr = (void *)ALIGN((uintptr_t)ptr + sizeof(void *), alignment);
        ((void **)ptr)[-1] = orig_ptr;
    }
    return ptr;
}

WASM_EXPORT void libdeflate_aligned_free(void *ptr)
{
    free((((void **)ptr)[-1]));
}
