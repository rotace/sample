/*
 * Copyright (C) 2018 John Donoghue <john.donoghue@ieee.org>
 *
 * This program is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see
 * <https://www.gnu.org/licenses/>.
 */
#include "LibraryBase.h"

#define ENC_L  2
#define ENC_R  3

volatile bool pin_l = false;
volatile bool pin_r = false;
volatile bool pin_old_l = false;
volatile bool pin_old_r = false;
volatile unsigned long count_l = 0;
volatile unsigned long count_r = 0;

void readEncoderL() {
  pin_l = digitalRead(ENC_L);
  if( pin_l == !pin_old_l ) count_l++;
  pin_old_l = pin_l;
}

void readEncoderR() {
  pin_r = digitalRead(ENC_R);
  if( pin_r == !pin_old_r ) count_r++;
  pin_old_r = pin_r;
}

#define CMDID_READ_COUNT 0x01

const char NO_NEED_VALUE[] PROGMEM = "No Needs a value to readCount";

class SingleEncoder : public LibraryBase
{
public:
  SingleEncoder(OctaveArduinoClass& a)
  {
    libName = "UserAddon/SingleEncoder";
    a.registerLibrary(this);
    attachInterrupt(digitalPinToInterrupt(ENC_L), readEncoderL, CHANGE);
    attachInterrupt(digitalPinToInterrupt(ENC_R), readEncoderR, CHANGE);
  }

  void commandHandler(uint8_t cmdID, uint8_t* data, uint8_t datasz)
  {
    unsigned long tmp;
    switch (cmdID)
    {
      case CMDID_READ_COUNT:
        if(datasz == 0){
          
          tmp = count_l;
          count_l = 0;
          data[0] = (tmp>>24)&0xff;
          data[1] = (tmp>>16)&0xff;
          data[2] = (tmp>>8)&0xff;
          data[3] = (tmp)&0xff;
          tmp = count_r;
          count_r = 0;
          data[4] = (tmp>>24)&0xff;
          data[5] = (tmp>>16)&0xff;
          data[6] = (tmp>>8)&0xff;
          data[7] = (tmp)&0xff;
          
          datasz = 8;
          sendResponseMsg(cmdID, data, datasz);
        }else{
          sendErrorMsg_P(NO_NEED_VALUE);
        }
        break;
        
      default:
        // notify of invalid cmd
        sendUnknownCmdIDMsg();
    }
  }
};

