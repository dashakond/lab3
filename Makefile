CXX = g++
CXXFLAGS = -Wall -g
TARGET = main
SRCS = main.cpp FuncA.cpp
OBJS = $(SRCS:.cpp=.o)

all: $(TARGET)

$(TARGET): $(OBJS)
    $(CXX) $(CXXFLAGS) -o $(TARGET) $(OBJS)

%.o: %.cpp
    $(CXX) $(CXXFLAGS) -c $< -o $@

clean:
    rm -f $(TARGET) $(OBJS)

