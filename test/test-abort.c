#include <unistd.h>
#include <string.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
int fuzz_one(const uint8_t *buf, size_t i) {

  if (i < 7) return 0;
  if (buf[0] != 'F') return 0;
  if (buf[1] != 'U') return 0;
  if (buf[2] != 'Z') return 0;
  if (buf[3] != 'Z') return 0;
  if (strncmp(buf + 4, "one", 3) == 0) abort();

  printf("%s", buf);
  return 0;

}

int main(int argc, char *argv[]) {

  unsigned char buf[1024];
  ssize_t       i;
  i = read(0, (char *)buf, sizeof(buf) - 1);
  if (i > 0) buf[i] = 0;
  fuzz_one(buf, i);

  return 0;

}
