function Col=CollMtx(A,r,O)

% Col=CollMtx(C4,5) circularly shifts the columns entries to the center
% specified in the second argument with reference to the thrid argument

A = squeeze(A);
m=size(A,2); % Extract the no. of cols

for i=1:m,
    Col(:,i)=circshift(A(:,i),r-O);
end
end


% Examples

% CollMtx(magic(5),3,1); 
