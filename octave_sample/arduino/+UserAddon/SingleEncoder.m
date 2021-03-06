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
      CMDID_CONTROL = hex2dec("02");
      CMDID_SYSIDT = hex2dec("03");
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

    function [count_l, count_r] = controlEncMotor(obj, rate_l, rate_r)
      cmdID = obj.CMDID_CONTROL;
      [tmp, sz] = sendCommand(obj.Parent, obj.LibraryName, cmdID, [uint8(rate_l*255), uint8(rate_r*255)]);
      count_l = uint32(tmp(1))*(256*256*256) + uint32(tmp(2))*(256*256) + uint32(tmp(3))*256 + uint32(tmp(4));
      count_r = uint32(tmp(5))*(256*256*256) + uint32(tmp(6))*(256*256) + uint32(tmp(7))*256 + uint32(tmp(8));
    end

    function outdata = systemIdent(obj, indata)
      cmdID = obj.CMDID_SYSIDT;
      if length(indata)>100
        data = indata(1:100)(:);
      else
        data = zeros(100,1);
        data(1:length(indata)) = indata(:);
      end
      timeout=20;
      [outdata, sz] = sendCommand(obj.Parent, obj.LibraryName, cmdID, uint8(indata.*255) ,timeout);
    end
    
  end
end
