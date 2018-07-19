StateMachine = Class {}

function StateMachine:init(states)
    self.empty = BaseState()
    self.states = states
    self.current = self.empty
end

function StateMachine:change(stateName, enterOptions)
    if enterOptions then
        print(enterOptions.score)
    end
    assert(self.states[stateName])
    self.current:exit()
    self.current = self.states[stateName]()
    self.current:enter(enterOptions)
end

function StateMachine:update(dt)
    self.current:update(dt)
end

function StateMachine:render()
    self.current:render()
end