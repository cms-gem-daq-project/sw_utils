Table of Contents
=================

   * [ADC counts to voltage conversion](#adc-counts-to-voltage-conversion)
      * [PT100 Sensors](#pt100-sensors)
      * [SCA Internal temperature](#sca-internal-temperature)
      * [Conversion of ADC for Voltage sensors](#conversion-of-adc-for-voltage-sensors)
      * [Reference](#reference)

Created by [gh-md-toc](https://github.com/ekalinin/github-markdown-toc)

# ADC counts to voltage conversion

The output values are 12 bit ADC and the voltage value varies from 0 to 1 V. Thus, each bit corresponds to 1/2^{12} =~ 0.244 mV.

## PT100 Sensors 

- ADC count = 44 (say)
- Corresponding voltage = 44 x 0.244 mV = 10.736 mV
- We are measuring temperature using the platenium resistor from which 100 $\mu$A current is passing.
- Resistance = V/I = 10.736mV / 100 $\mu$ A = 107.36  $\Omega$
- Check the temperature corresponding to the 107.36 $\Omega$ resistance in the R - T table [1]. This corresponds to ~19 $^0 C$.

## SCA Internal temperature

- ADC count = 2743
- Corresponding voltage = 2743 X 0.244 mV = 669.68 mV
- Now look at the V-T graph. The voltage of 669.68 corresponds to ~25 $^0 C$.

<img width="928" alt="upload_70214b9a453866df6201dd01a97f9573" src="https://user-images.githubusercontent.com/5220316/58358921-32d1c500-7e81-11e9-8ae6-ae5c3a6805df.png">

The above V-T graph is taken from page 52 of GBT-SCA manual [2]

## Conversion of ADC for Voltage sensors

- ADC count = 1025
- As we can see from the image below there is a voltage divider having two resistor having values 3k and 1k each. So, need to multiply this by 4.

![upload_65554560d042b44d9ed7369b6cea3992](https://user-images.githubusercontent.com/5220316/58358934-48df8580-7e81-11e9-83c6-d29534acf581.png)

- Voltage  = 1025 * 0.244 * 4 mV ~= 1V

---

## Reference

1. [https://www.intech.co.nz/products/temperature/typert/RTD-Pt100-Conversion.pdf](https://www.intech.co.nz/products/temperature/typert/RTD-Pt100-Conversion.pdf)

2. [https://espace.cern.ch/GBT-Project/GBT-SCA/Manuals/GBT-SCA-UserManual.pdf](https://espace.cern.ch/GBT-Project/GBT-SCA/Manuals/GBT-SCA-UserManual.pdf)