from abc import abstractmethod
from multiprocessing.pool import ThreadPool
import numpy as np


ENERGY_DICT = {'AA': 10}

def read_energy():
    pass


class Job():

    @staticmethod
    def execute(job):
        return job.run()

    def __init__(self):
        self.result = None

    @abstractmethod
    def run(self):
        return self

class FastaToEnergy(Job):

    energy_dict = ENERGY_DICT

    def __init__(self, header, sequence):
        self.header = header
        self.sequence = sequence
        super().__init__()
    
    def run(self):
        values = np.zeros(len(self.sequence))
        for i in range(len(self.sequence)-1):
            di_nuc = self.sequence[i] + self.sequence[i+1].upper()
            values[i] = FastaToEnergy.energy_dict[di_nuc]
        self.result = values
        return self



            


