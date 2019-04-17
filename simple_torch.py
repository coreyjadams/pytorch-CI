import torch

# Build a graph.
a = torch.tensor([1.0, 2.0, 3.0])
b = torch.tensor([5.0, 5.0, 5.0])
c = a * b


print("Success: torch succeeded")