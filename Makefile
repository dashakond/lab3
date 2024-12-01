CXX = g++
CXXFLAGS = -std=c++11

all: main server

main: main.o func.o
	$(CXX) $(CXXFLAGS) -o main main.o func.o

server: server.o func.o
	$(CXX) $(CXXFLAGS) -o server server.o func.o

main.o: main.cpp
	$(CXX) $(CXXFLAGS) -c main.cpp

server.o: server.cpp
	$(CXX) $(CXXFLAGS) -c server.cpp

func.o: func.cpp func.h
	$(CXX) $(CXXFLAGS) -c func.cpp

clean:
	rm -f *.o main server

