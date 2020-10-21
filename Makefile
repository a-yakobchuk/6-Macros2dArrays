CC = gcc
CPP = g++
CPPFLAGS = -Wall -pedantic -DEN_TIME 
CFLAGS = -Wall -std=c99 -pedantic -O1 -DEN_TIME
SOURCE = hw6c.c 
CPPSOURCE = hw6cpp.cpp 
OBJ = $(patsubst %.c, %.o, $(SOURCE))
CPPOBJ = $(patsubst %.cpp, %.o, $(CPPSOURCE))
EXE = hw6c 
CPPEXE = hw6cpp 
VALGRIND = valgrind --tool=memcheck --leak-check=yes --track-origins=yes 
RESULTS = out.txt
TESTTXT = data.txt
MEMTXT = valgrindOut.txt

.SILENT:
all: $(EXE) $(CPPEXE) 

$(EXE): $(OBJ)
	@echo "Linking C program"
	$(CC) $(OBJ) -o $(EXE)

$(CPPEXE): $(CPPOBJ)
	@echo "Linking CPP program"
	$(CPP) $(CPPOBJ) -o $(CPPEXE)

.c.o: 
	@echo "Compiling C program $*.c"
	$(CC) $(CFLAGS) $*.c -c

.cpp.o: 
	@echo "Compiling CPP program $*.cpp"
	$(CPP) $(CPPFLAGS) $*.cpp -c

test: $(EXE) $(CPPEXE)
	@echo "running the C code"
	./$(EXE) $(TESTTXT) > $(RESULTS)
	@echo "running the C++ code"
	./$(CPPEXE) $(TESTTXT) >> $(RESULTS)
	cat $(RESULTS)

.PHONY: mem clean test all help
mem: $(EXE) $(CPPEXE)
	@echo "running valgrind, will take a few mins"
	$(VALGRIND) ./$(EXE) $(TESTTXT) > $(MEMTXT) 2>&1
	cat $(MEMTXT)

clean: 
	-rm -f $(OBJ) $(CPPOBJ) $(CPPEXE) $(EXE) $(RESULTS) $(MEMTXT)

help:
	@echo "make options are: all, clean, mem, test"

