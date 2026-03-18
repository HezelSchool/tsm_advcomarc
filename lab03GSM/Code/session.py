import time
from config import SESSION_DURATION

class Session:
    def __init__(self, kc):
        self.kc = kc
        self.created_at = time.time()

    def is_valid(self):
        return (time.time() - self.created_at) < SESSION_DURATION