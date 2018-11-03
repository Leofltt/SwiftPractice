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

maxalloc 2, 5

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
kamp chnget "level"
kamp port kamp, .001
kamp /= 5
kenv        linsegr        0,          .001,         1,      .01,     1,     .1, 0
asig loscil kenv, cpsmidinn(p4), 2, 65.41, p6
outs      asig*kamp, asig*kamp
endin


instr 100
kfb chnget "reverb"
kfb port kfb, .001
arL, arR    reverbsc    garvb, garvb, kfb, 10000
outs        arL*.3, arR*.3
clear   garvb
endin

</CsInstruments>
<CsScore>

f0 z

f2  0    0   1 "WAVs/choir.wav"          0 0 0

</CsScore>
</CsoundSynthesizer>


