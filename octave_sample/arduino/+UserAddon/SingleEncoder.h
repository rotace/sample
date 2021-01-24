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

#define MOT_RF 5
#define MOT_RB 6
#define MOT_LF 9
#define MOT_LB 10
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
#define CMDID_CONTROL    0x02
#define CMDID_SYSIDT     0x03

const char INPUT_VALUE_INCORRECT[] PROGMEM = "Input Value Incorrect";

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
          sendErrorMsg_P(INPUT_VALUE_INCORRECT);
        }
        break;

      case CMDID_CONTROL:
        if(datasz == 2){

          analogWrite(MOT_LF, data[0]);
          analogWrite(MOT_RF, data[1]);
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
          sendErrorMsg_P(INPUT_VALUE_INCORRECT);
        }
        break;

      case CMDID_SYSIDT:

        for(int i=0;i<100;i++){

          analogWrite(MOT_LF, data[i]);
          data[i] = (uint8_t)count_l;
          count_l = 0;

          // analogWrite(MOT_RF, data[i]);
          // data[i] = (uint8_t)count_r;
          // count_r = 0;

          delay(100);

        }
        analogWrite(MOT_LF, 0);
        analogWrite(MOT_RF, 0);
        datasz = 100;
        sendResponseMsg(cmdID, data, datasz);
        break;

      default:
        // notify of invalid cmd
        sendUnknownCmdIDMsg();
    }
  }
};

