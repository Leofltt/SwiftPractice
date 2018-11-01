<CsoundSynthesizer>
<CsOptions>
-odac
</CsOptions>
<CsInstruments>

sr        = 44100
ksmps     = 64
nchnls    = 2
0dbfs	  = 1.0

garvb    init   0
gadist init 0
instr 1

khar chnget "harmony"
khar port khar, 0.01
kvol chnget "volume"
kvol port kvol, 0.01

asig,asig1 ins

fsig1 pvsanal asig,1024,256,2048,1
fsig2 pvscale fsig1,0.75+khar,1
fsig3 pvscale fsig1,(0.75+khar)*1.25,1
fsig4 pvsmix fsig2, fsig3
a1 pvsynth fsig4

garvb += a1
gadist += a1

a1 = a1 * kvol
   outs a1, a1
endin

instr 2

endin


instr 100
kfb chnget "reverb"
kfb port kfb, .001
arL, arR    reverbsc    garvb, garvb, kfb, 10000
outs        arL*.3, arR*.3
clear   garvb
endin

instr 101
kdist chnget "distortion"
kdist port dist, 0.01
a1 distort gadist, kdist, 1
clear gadist
endin

</CsInstruments>
<CsScore>
;table for distortion
f 1 0 16384 10 1

i100 0  -1

</CsScore>
</CsoundSynthesizer>
