function s = soft(y,lambda)
    s = sign(y).*( max( 0, abs(y)-lambda ) );
end 