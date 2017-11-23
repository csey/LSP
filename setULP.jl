# --------------------------------------------------------------------------- #

# Setting an ip model of SPP
function setULP(solverSelected, D, P, H, F, C)
  t = length(D)
  ip = Model(solver=solverSelected)

  #Variables definitions
  @variable(ip, X[1:t] >= 0)
  @variable(ip, Y[1:t] <= 1 )
  @variable(ip, S[1:t] >= 0)

  #Objectives functions
  @objective(ip, Min,
                    sum(H[i] * S[i] for i=1:t) +
                    sum(P[i] * X[i] for i=1:t) +
                    sum(F[i] * Y[i] for i=1:t))

  #Constraints of problem
  @constraint(ip , cte1[i=2:t], X[i]+S[i-1]-D[i]-S[i] == 0)
  @constraint(ip , cte2[i=1:t], X[i]-11 * Y[i] <= 0)
  @constraint(ip , cte3, X[1]-D[1]-S[1] == 0)
  for i=1:t
    if C[i] != 2
        @constraint(ip , Y[i] == C[i])
    end
  end

  return ip, X, Y, S
end
#--------------------------------------------------------------------------------------------------------------------------
function setULPMIP(solverSelected,D,P,H,F)
  t = length(D)
  ip = Model(solver=solverSelected)

  #Variables definitions
  @variable(ip, X[1:t] >= 0)
  @variable(ip, Y[1:t], Bin )
  @variable(ip, S[1:t] >= 0)

  #Objectives functions
  @objective(ip, Min,
                    sum(H[i] * S[i] for i=1:t) +
                    sum(P[i] * X[i] for i=1:t) +
                    sum(F[i] * Y[i] for i=1:t))

  #Constraints of problem
  @constraint(ip , cte1[i=2:t], X[i]+S[i-1]-D[i]-S[i] == 0)
  @constraint(ip , cte2[i=1:t], X[i]-2 * Y[i] <= 0)
  @constraint(ip , cte3, X[1]-D[1]-S[1] == 0)
  for i=1:t
    if C[i] != 2
        @constraint(ip , Y[i] == C[i])
    end
  end

  return ip, X, Y, S
end
