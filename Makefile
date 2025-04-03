.PHONY: all clean

SOURCES = utils/allocator.c \
	libdeflate/allocator.c \
	libdeflate/deflate_compress.c \
	libdeflate/deflate_decompress.c \
	libdeflate/gzip_decompress.c \
	libdeflate/zlib_compress.c \
	libdeflate/adler32.c \
	crypto/aes256.c \
	crypto/ige256.c \
	crypto/ctr256.c \
	hash/sha256.c \
	hash/sha1.c \
	utils/webp.c \
	libwebp/src/dec/alpha_dec.c libwebp/src/dec/buffer_dec.c libwebp/src/dec/frame_dec.c libwebp/src/dec/idec_dec.c libwebp/src/dec/io_dec.c libwebp/src/dec/quant_dec.c libwebp/src/dec/tree_dec.c libwebp/src/dec/vp8_dec.c libwebp/src/dec/vp8l_dec.c libwebp/src/dec/webp_dec.c libwebp/src/dsp/alpha_processing.c libwebp/src/dsp/alpha_processing_mips_dsp_r2.c libwebp/src/dsp/alpha_processing_neon.c libwebp/src/dsp/alpha_processing_sse2.c libwebp/src/dsp/alpha_processing_sse41.c libwebp/src/dsp/cost.c libwebp/src/dsp/cost_mips32.c libwebp/src/dsp/cost_mips_dsp_r2.c libwebp/src/dsp/cost_neon.c libwebp/src/dsp/cost_sse2.c libwebp/src/dsp/cpu.c libwebp/src/dsp/dec.c libwebp/src/dsp/dec_clip_tables.c libwebp/src/dsp/dec_mips32.c libwebp/src/dsp/dec_mips_dsp_r2.c libwebp/src/dsp/dec_msa.c libwebp/src/dsp/dec_neon.c libwebp/src/dsp/dec_sse2.c libwebp/src/dsp/dec_sse41.c libwebp/src/dsp/enc.c libwebp/src/dsp/enc_mips32.c libwebp/src/dsp/enc_mips_dsp_r2.c libwebp/src/dsp/enc_msa.c libwebp/src/dsp/enc_neon.c libwebp/src/dsp/enc_sse2.c libwebp/src/dsp/enc_sse41.c libwebp/src/dsp/filters.c libwebp/src/dsp/filters_mips_dsp_r2.c libwebp/src/dsp/filters_msa.c libwebp/src/dsp/filters_neon.c libwebp/src/dsp/filters_sse2.c libwebp/src/dsp/lossless.c libwebp/src/dsp/lossless_enc.c libwebp/src/dsp/lossless_enc_mips32.c libwebp/src/dsp/lossless_enc_mips_dsp_r2.c libwebp/src/dsp/lossless_enc_msa.c libwebp/src/dsp/lossless_enc_neon.c libwebp/src/dsp/lossless_enc_sse2.c libwebp/src/dsp/lossless_enc_sse41.c libwebp/src/dsp/lossless_mips_dsp_r2.c libwebp/src/dsp/lossless_msa.c libwebp/src/dsp/lossless_neon.c libwebp/src/dsp/lossless_sse2.c libwebp/src/dsp/lossless_sse41.c libwebp/src/dsp/rescaler.c libwebp/src/dsp/rescaler_mips32.c libwebp/src/dsp/rescaler_mips_dsp_r2.c libwebp/src/dsp/rescaler_msa.c libwebp/src/dsp/rescaler_neon.c libwebp/src/dsp/rescaler_sse2.c libwebp/src/dsp/ssim.c libwebp/src/dsp/ssim_sse2.c libwebp/src/dsp/upsampling.c libwebp/src/dsp/upsampling_mips_dsp_r2.c libwebp/src/dsp/upsampling_msa.c libwebp/src/dsp/upsampling_neon.c libwebp/src/dsp/upsampling_sse2.c libwebp/src/dsp/upsampling_sse41.c libwebp/src/dsp/yuv.c libwebp/src/dsp/yuv_mips32.c libwebp/src/dsp/yuv_mips_dsp_r2.c libwebp/src/dsp/yuv_neon.c libwebp/src/dsp/yuv_sse2.c libwebp/src/dsp/yuv_sse41.c libwebp/src/demux/anim_decode.c libwebp/src/demux/demux.c libwebp/src/utils/bit_reader_utils.c libwebp/src/utils/bit_writer_utils.c libwebp/src/utils/color_cache_utils.c libwebp/src/utils/filters_utils.c libwebp/src/utils/huffman_encode_utils.c libwebp/src/utils/huffman_utils.c libwebp/src/utils/palette.c libwebp/src/utils/quant_levels_dec_utils.c libwebp/src/utils/quant_levels_utils.c libwebp/src/utils/random_utils.c libwebp/src/utils/rescaler_utils.c libwebp/src/utils/thread_utils.c libwebp/src/utils/utils.c

WASM_CC ?= emcc
CC := $(WASM_CC)

EMCC_OPTS=-Wunused -O3 -flto=full -s NO_DYNAMIC_EXECUTION=1 -s NO_FILESYSTEM=1 -s EXPORTED_FUNCTIONS="['_malloc', '_free']" -s MODULARIZE=1 -s NODEJS_CATCH_EXIT=0 -s NODEJS_CATCH_REJECTION=0

EMCC_NASM_OPTS=-s WASM=0 -s WASM_ASYNC_COMPILATION=0 -s ENVIRONMENT=web,worker --closure 1 -s INCOMING_MODULE_JS_API="['locateFile']" -s TEXTDECODER=0


CFLAGS := $(EMCC_NASM_OPTS) ${EMCC_OPTS}

ifneq ($(OS),Windows_NT)
    UNAME_S := $(shell uname -s)
	ifeq ($(UNAME_S),Darwin)
		export PATH := /opt/homebrew/opt/llvm/bin/:$(PATH)
    endif
endif

OUT := ./mtcute.wasm

# $(OUT): $(SOURCES)
# 	$(CC) $(CFLAGS) -I . -I utils -I libwebp -o $@ $^

clean:
	rm -f $(OUT)

compile:
	emcc $(CFLAGS) -I . -I utils -I libwebp -o mtcute.asm.js $(SOURCES)
