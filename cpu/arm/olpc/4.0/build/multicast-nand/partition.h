#include "stdint.h"

#define MAX_PARTITIONS 16
#define MAX_PARTITION_NAME 32

struct partition_spec {
	char     name[MAX_PARTITION_NAME];	/* */
	uint32_t total_eblocks;		/* Num to allocate if creating new map */
	uint32_t used_eblocks;		/* Num needed for the current update */
	uint32_t flags;			/* Special considerations */
};

struct partition_map_spec {
	uint32_t version;
	uint32_t nr_partitions;
	struct partition_spec partitions[];
};

enum block_states {
	LEAVE_ALONE,
	ERASED,
	PENDING,
	WRITTEN,
	CLEANED,
	READY,
	PARTIAL,
	BAD,
	WILL_CLEAN
};
