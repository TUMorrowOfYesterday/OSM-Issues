import csv
import cv2
import torch
import torch.nn as nn
import torch.nn.functional as F
import numpy as np
from torch.utils.data import Dataset, DataLoader
import albumentations as A



def crop(image):
    h, w, _ = image.shape
    s = min(w, h)
    x, y = (w-s)//2, (h-s)//2
    cropped = image[y:y+s, x:x+s]
    return cropped

# Dataset
class LabelledImageDataset(Dataset):
    def __init__(self, dataset_dir, transform=None):
        # read csv with csvReader
        with open(dataset_dir+'/labels.csv', 'r', encoding='utf-8') as csvFile:
            reader = csv.reader(csvFile)
            columns = next(reader)
            assert(columns == ['image_id', 'highway'])

            self.rows = []
            for img_path, label in reader:
                self.rows.append((f"{dataset_dir}/{img_path}.jpg", label == 'primary'))

        self.transform = transform

    def __len__(self):
        return len(self.rows)
    
    def __getitem__(self, index):
        img_path, is_highway =  self.rows[index]
        image = crop(cv2.imread(img_path))
        image = image[:, :, ::-1] # TODO: why?

        # apply transforms
        if self.transform is not None:
            res = self.transform(image=image)
            image = res['image'].astype(np.float32)
        else:
            image = image.astype(np.float32)
        
        # transpose to (C, H, W)
        image = image.transpose(2, 0, 1)

        return torch.tensor(image).float(), torch.tensor(is_highway).float().unsqueeze(0)


class SingleImageDataset(Dataset):
    def __init__(self, img_path, transform=None):
        self.image = crop(cv2.imread(img_path))[:, :, ::-1]

        if transform is not None:
            res = transform(image=self.image)
            self.image = res['image'].astype(np.float32)
        else:
            self.image = self.image.astype(np.float32)
        
        # transpose to (C, H, W)
        self.image = self.image.transpose(2, 0, 1)

        self.image = torch.tensor(self.image).float()

    def __len__(self):
        return 1
    
    def __getitem__(self, index):
        return self.image





# Model

class ImageBinClassificationBase(nn.Module):
    pass
    # def training_step(self, batch):
    #     images, labels = batch 
    #     out = self(images)                  # Generate predictions
    #     loss = F.binary_cross_entropy(out, labels) # Calculate loss
    #     return loss
    
    # def validation_step(self, batch):
    #     images, labels = batch 
    #     out = self(images)                    # Generate predictions
    #     loss = F.binary_cross_entropy(out, labels) # Calculate loss
    #     acc = accuracy(out, labels)           # Calculate accuracy
    #     return {'val_loss': loss.detach(), 'val_acc': acc}
        
    # def validation_epoch_end(self, outputs):
    #     batch_losses = [x['val_loss'] for x in outputs]
    #     epoch_loss = torch.stack(batch_losses).mean()   # Combine losses
    #     batch_accs = [x['val_acc'] for x in outputs]
    #     epoch_acc = torch.stack(batch_accs).mean()      # Combine accuracies
    #     return {'val_loss': epoch_loss.item(), 'val_acc': epoch_acc.item()}
    
    # def epoch_end(self, epoch, result):
    #     print("Epoch [{}], train_loss: {:.4f}, val_loss: {:.4f}, val_acc: {:.4f}".format(
    #         epoch, result['train_loss'], result['val_loss'], result['val_acc']))


class HighwayClassifier(ImageBinClassificationBase):
    def __init__(self):
        super().__init__()
        self.network = nn.Sequential(
            
            nn.Conv2d(3, 32, kernel_size = 3, padding = 1),
            nn.ReLU(),
            nn.Conv2d(32,64, kernel_size = 3, stride = 1, padding = 1),
            nn.ReLU(),
            nn.MaxPool2d(2,2),
        
            nn.Conv2d(64, 128, kernel_size = 3, stride = 1, padding = 1),
            nn.ReLU(),
            nn.Conv2d(128 ,128, kernel_size = 3, stride = 1, padding = 1),
            nn.ReLU(),
            nn.MaxPool2d(2,2),
            
            nn.Conv2d(128, 256, kernel_size = 3, stride = 1, padding = 1),
            nn.ReLU(),
            nn.Conv2d(256,256, kernel_size = 3, stride = 1, padding = 1),
            nn.ReLU(),
            nn.MaxPool2d(2,2),
            
            nn.Flatten(),
            nn.Linear(82944,1024),
            nn.ReLU(),
            nn.Linear(1024, 512),
            nn.ReLU(),
            nn.Linear(512,1),
            nn.Sigmoid() # convert logits to probabilities
        )
    
    def forward(self, xb):
        return self.network(xb)
