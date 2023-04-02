import torch
import torchvision
import torchvision.transforms as transforms
import torch.nn as nn
import torch.nn.functional as F
import torch.optim as optim
import functools
import datetime
batch_size = 4
device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
#device = torch.device('cpu')
print(f'We are using {device.type}')
transform = transforms.Compose(
    [transforms.ToTensor(),
     transforms.Normalize((0.5), (0.5))]
)
trainset = torchvision.datasets.MNIST(root='./data', train=True, download=True, transform=transform)
trainloader = torch.utils.data.DataLoader(trainset, batch_size=batch_size, shuffle=True, num_workers=2)
testset = torchvision.datasets.MNIST(root='./data', train=False, download=True, transform=transform)
testloader = torch.utils.data.DataLoader(testset, batch_size=batch_size, shuffle=False, num_workers=2) 

class Net(nn.Module): 
    def __init__(self, debug=False):
        super(Net, self).__init__() 
        self.c1 = nn.Conv2d(in_channels=1, out_channels=6, kernel_size=5) 
        self.c2 = nn.Conv2d(6, 16, 5)                                                                                                                    
        self.l1 = nn.Linear(16 * 4 * 4, 120)                                                                                                             
        self.l2 = nn.Linear(120, 84)                                                                                                                     
        self.l3 = nn.Linear(84, 10)                                                                                                                      
        if debug: 																																		 
            params = list(self.parameters())                                                                                                             
            print(params[0])  																															 
            print(params[1])  																															 
    def forward(self, x):                                                                                                                                
        x = self.c1(x)                    																												 
        x = F.relu(x)                                                                                                                                    
        x = F.max_pool2d(x, (2, 2))       																												 
        x = self.c2(x)                    																												 
        x = F.relu(x)                                                                                                                                    
        x = F.max_pool2d(x, 2)            																												 
        nof = functools.reduce(lambda i, j: i*j, x.shape[1:])                                                                                            
        x = x.view(-1, nof)               																												 
        x = self.l1(x)                    																												 
        x = F.relu(x)                                                                                                                                    
        x = self.l2(x)                    																												 
        x = F.relu(x)                                                                                                                                    
        x = self.l3(x)                    																												 
        return x         
        
net = Net().to(device)                                                                                                                                   
criterion = nn.CrossEntropyLoss()                                                                                                                        
optimizer = optim.SGD(net.parameters(), lr=0.001, momentum=0.9)   

print('Begin Training')  
print(datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%M"))
for epoch in range(2):  																																 
    running_loss = 0.0                                                                                                                                   
    for i, (inputs, labels) in enumerate(trainloader, start=0):                                                                                          
        inputs, labels = inputs.to(device), labels.to(device)                                                                                            
        outputs = net(inputs)                                                                                                                            
        loss = criterion(outputs, labels)                                                                                                                
        optimizer.zero_grad()                                                                                                                            
        loss.backward()                                                                                                                                  
        optimizer.step()                                                                                                                                 
        running_loss += loss.item()                                                                                                                      
        if i % 2000 == 1999:    																														 
            print(f'[{epoch + 1}, {i + 1:5d}] loss: {running_loss / 2000:.3f}')                                                                          
            running_loss = 0.0          

print('Finished Training')  
print(datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%M"))
                                                                                                                             
correct = 0                                                                                                                                              
total = 0                                                                                                                                                
with torch.no_grad():                                                                                                                                    
    for inputs, labels in testloader:                                                                                                                    
        images, labels = inputs.to(device), labels.to(device)                                                                                            
        outputs = net(images)                                                                                                                            
        _, predicted = torch.max(outputs.data, 1)                                                                                                        
        total += labels.size(0)                                                                                                                          
        correct += (predicted == labels).sum().item()             
        
print(f'Accuracy of the network on the 10000 test images: {100 * correct // total} %')
print(datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%M"))