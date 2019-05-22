# import re
import matplotlib.pyplot as plt
import numpy as np
import sys


def read_file(filename):
    """Reads file and returns two vectors: x and y

    Returns:
      x,y:
          x: list of timestamp in hex format
          y: list of integers

    File line sample:
        4000000058bb464e:TROPF$1#1:40

    """
    x, y = [], []
    with open(filename, "r") as f:
        for line in f:
            xi, _, yi = line.strip().split(":")
            x.append(xi)
            y.append(int(yi))
    return x, y


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Please inform the filename")
        sys.exit()
    filename = sys.argv[1]
    x, y = read_file(filename)
    # print(y)


    y1 = np.diff(y)
    y2 = y1.copy()
    y2[y2 < 0] += 255

    p1 = plt.subplot(311)
    plt.plot(y)
    plt.title('counts')

    plt.subplot(312, sharex=p1)
    plt.plot(y1)
    plt.title('diff counts')
    
    plt.subplot(313, sharex=p1)
    plt.plot(y2)
    plt.title('diff counts corrected')
    
    plt.show()
            
