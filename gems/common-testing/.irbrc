# frozen_string_literal: true

root_rc = File.join(__dir__, "../../.irbrc")
if File.file?(root_rc)
  load(root_rc)
end
