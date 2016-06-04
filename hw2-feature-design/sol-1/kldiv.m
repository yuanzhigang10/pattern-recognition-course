function KL = kldiv(pVect1, pVect2)

%% add eps, renormalize
eps = 1e-6;
if sum(pVect1==0) > 0
    pVect1(pVect1==0) = eps;
    pVect1 = pVect1 / sum(pVect1);
end
if sum(pVect2==0) > 0
    pVect2(pVect2==0) = eps;
    pVect2 = pVect2 / sum(pVect2);
end

%% Kullback-Leibler
KL1 = sum(pVect1 .* (log2(pVect1)-log2(pVect2)));
KL2 = sum(pVect2 .* (log2(pVect2)-log2(pVect1)));
KL = (KL1+KL2) / 2;

end