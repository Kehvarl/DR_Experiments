
def tick args
  args.state.gt ||= Defender.new(args)
  args.state.gt.tick(args)
end
