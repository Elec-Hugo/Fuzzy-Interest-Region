function out=SelectFile()
d=dir('data\parts of picture\');
fprintf('which image do you want to process?\n');

s=sprintf('Please enter a number from 1 to %d :',length(d)-2);

for j=3:length(d)
fprintf(sprintf('%d-%s\n',(j-2),d(j).name));
end
out = 2+input(s);
end
