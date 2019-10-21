all: txt/train txt/valid txt/test

txt/train: txt/all
	cat txt/all | grep -v '^#' | awk 'NR % 13 < 10' > $@

txt/valid: txt/all
	cat txt/all | grep -v '^#' | awk 'NR % 13 == 10' > $@

txt/test: txt/all
	cat txt/all | grep -v '^#' | awk 'NR % 13 > 10' > $@

txt/all:
	mkdir -p txt
	bash download.sh > $@

clean:
	rm -rf txt
