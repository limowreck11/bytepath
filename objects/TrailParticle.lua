TrailParticle = GameObject:extend()

function TrailParticle:new(area, x, y, opts)
    TrailParticle.super.new(self, area, x, y, opts)

    self.r = opts.r or random(4, 6)
    self.timer:tween(opts.d or random(0.3, 0.5), self, {r = 0}, 'linear', 
    function() self.dead = true end)

    self.y_offset = 0
    self.timer:tween(0.13, self, {r = 0, y_offset = 32}, 'in-out-cubic', 
        function() self.dead = true end)
end

function TrailParticle:update(dt)
    TrailParticle.super.update(self, dt)

    print(self.parent)
    if self.parent then self.x, self.y = self.parent.x, self.parent.y - self.y_offset end
end

function TrailParticle:draw()
    TrailParticle.super.draw(self)

    -- TODO
end