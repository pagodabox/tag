-- -*- mode: lua; tab-width: 2; indent-tabs-mode: 1; st-rulers: [70] -*-
-- vim: ts=4 sw=4 ft=lua noet
----------------------------------------------------------------------
-- @author Daniel Barney <daniel@pagodabox.com>
-- @copyright 2015, Pagoda Box, Inc.
-- @doc
--
-- @end
-- Created :   21 May 2015 by Daniel Barney <daniel@pagodabox.com>
----------------------------------------------------------------------

local Cauterize = require('cauterize')
local log = require('logger')

local Basic = require('./basic/basic')
local Replication = require('./replicated/replicated')
local Sync = require('./replicated/sync')

local Store = Cauterize.Supervisor:extend()

function Store:_manage()
  local replicated_db = Cauterize.Supervisor.call('config','get',
    'replicated_db')

  if replicated_db == true then
    log.info('enabling replicated mode')
    self:manage(Replication)
        :manage(Sync,'supervisor')
  else
    log.info('enabling non-replicated mode')
    self:manage(Basic)
  end
end

return Store