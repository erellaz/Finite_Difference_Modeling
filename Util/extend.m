%% Mirror extend a cube in 3 dimensions
% Synopsis:  
%v=extend(model,[toptaper,taper,taper],[taper,taper,taper],'same','same');
% E output extended cube in the 3 dimensions with different method
% mirror, zeros, constant
% to be used to take care of the edge effect of some algorithms 
% all tapers are positive
% the first set of 3 extend towards positive indices, the second toward
% negative indices

function E=extend(S,isizepos,isizeneg,kind,kindtop)
%% Load the 3D seismic cube
pi=isizepos(1);
pj=isizepos(2);
pk=isizepos(3);
qi=isizeneg(1);
qj=isizeneg(2);
qk=isizeneg(3);

[ni,nj,nk]=size(S);

% Initialize the output
E=zeros(ni+pi+qi,nj+pj+qj,nk+pk+qk);
% Paste the input in the middle
E(pi+1:pi+ni,pj+1:pj+nj,pk+1:pk+nk)=S(:,:,:);
    
switch kind
    case 'zeros'
    return;

    otherwise
    %Mirror extend along i
    E(1:pi,pj+1:pj+nj,pk+1:pk+nk)=flip(S(1:pi,:,:),1);
    E(pi+ni+1:pi+qi+ni,pj+1:pj+nj,pk+1:pk+nk)=flip(S(ni-(qi-1):ni,:,:),1);

    %Mirror extend along j
    E(:,1:pj,:)=flip(E(:,pj+1:2*pj,:),2);
    E(:,pj+nj+1:pj+qj+nj,:)=flip(E(:,nj+pj-qj+1:nj+pj,:),2);  

    %Mirror extend along k
    top=flip(E(:,:,pk+1:2*pk),3);
    
      switch kindtop
        case 'same'
            E(:,:,1:pk)=top;
        case 'zeros'
            E(:,:,1:pk)=top.*0;
          otherwise % ie case 'air'
            E(:,:,1:pk)=top.*0+300;
      end
    E(:,:,pk+nk+1:pk+qk+nk)=flip(E(:,:,nk+pk-qk+1:nk+pk),3);  
end
