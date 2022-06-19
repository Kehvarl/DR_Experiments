
def SimulateTicks(startingState, numberOfTicks)
  (0..numberOfTicks-1).each do |t|
    startingState = startingState.map_with_index do |c,i|
      c0 = startingState[i-1] || 0
      c1 = startingState[i+1] || 0
      (c0 != c1) ? 1: 0
    end
  end
  return startingState
end
