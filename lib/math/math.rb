module Math

  # pred: What you thought it was
  # act: What it actually was
  def self.logLoss(pred, act, eps=1e-15)
    pred = [eps, pred].max
    pred = [1-eps, pred].min
    ll = act * Math.log(pred) + (1-act) * Math.log(1-pred)
    ll = ll * -1
    return ll
  end
end
