<CsoundSynthesizer>
<CsOptions>
-odac -d
-iadc -d
</CsOptions>
<CsInstruments>

sr        = 44100
ksmps     = 64
nchnls    = 2
0dbfs	  = 1.0

garvb        init        0
garvb1       init       0

instr 1

kvol chnget "volume"
khar chnget "harmony"

kdst    chnget  "distortion"
kdst    port    kdst, 0.01

krate chnget "ratio"
krate port krate, 0.01

asig, asig1 ins
fsig1 pvsanal asig,2048,256,2048,1
fsig2 pvscale fsig1,khar+0.75,1
fsig3 pvscale fsig1,(0.75 + khar)*1.25,1
fsig4 pvsmix fsig2, fsig3
a1 pvsynth fsig4

adL distort1 a1, 2, 0.5, 0.05, 0
adel vdelay a1, krate, 5000

garvb += a1
a1 = asig * kvol
outs a1 + adL*kdst + adel, a1 + adL*kdst + adel
endin


instr 2
kgain chnget "gain"
asig2, asig3 ins
a2 = asig2*kgain
a3 = asig3*kgain

a2 += garvb1
a3 += garvb1
outs a2, a3
endin


instr 100
kfb chnget "reverb"
kfb port kfb, .001
arL, arR    reverbsc    garvb, garvb, kfb, 10000
outs        arL*.3, arR*.3
clear   garvb
endin



instr 101
kfb chnget "reverb1"
kfb port kfb, .001
arL, arR    reverbsc    garvb, garvb, kfb, 10000
outs        arL*.3, arR*.3
clear   garvb1
endin


</CsInstruments>
<CsScore>


</CsScore>
</CsoundSynthesizer>


