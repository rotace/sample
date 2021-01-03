%% Copyright (C) 2018-2020 John Donoghue <john.donoghue@ieee.org>
%% 
%% This program is free software: you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation, either version 3 of the License, or
%% (at your option) any later version.
%% 
%% This program is distributed in the hope that it will be useful, but
%% WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%% GNU General Public License for more details.
%% 
%% You should have received a copy of the GNU General Public License
%% along with this program.  If not, see
%% <https://www.gnu.org/licenses/>.

classdef SingleEncoder < arduinoio.LibraryBase
  properties(Access = private, Constant = true)
      ECHO_COMMAND = hex2dec("00");
      CMDID_READ_COUNT = hex2dec("01");
  end

  properties(Access = protected, Constant = true)
    LibraryName = 'UserAddon/SingleEncoder';
    DependentLibraries = {};
    ArduinoLibraryHeaderFiles = {};
    CppHeaderFile = fullfile(arduinoio.FilePath(mfilename('fullpath')), 'SingleEncoder.h');
    CppClassName = 'SingleEncoder';
  end

  methods
    % constructor
    function obj = SingleEncoder(parentObj)
      obj.Parent = parentObj;
      obj.Pins = [];
    end

    function [count_l, count_r] = readEncCount(obj)
      cmdID = obj.CMDID_READ_COUNT;
      [tmp, sz] = sendCommand(obj.Parent, obj.LibraryName, cmdID, []);
      count_l = uint32(tmp(1))*(256*256*256) + uint32(tmp(2))*(256*256) + uint32(tmp(3))*256 + uint32(tmp(4));
      count_r = uint32(tmp(5))*(256*256*256) + uint32(tmp(6))*(256*256) + uint32(tmp(7))*256 + uint32(tmp(8));
    end
   
  end
end
