function y=findss(Q)
    % Set last row of Q matrix to ones so that all eqs. are indep. NB on syntax: size(Q,1) is the size of the first dimension(rows) of Q.
    Q(size(Q,1),:)=ones(1,size(Q,2));
    % Derivatives are all zero and sum of last row is 1
    y=zeros(size(Q,1),1);
    y(length(y))=1;
    y=inv(Q)*y;