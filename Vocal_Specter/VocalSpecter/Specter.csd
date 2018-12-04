<CsoundSynthesizer>
<CsOptions>
-odac
</CsOptions>
<CsInstruments>

sr        = 44100
ksmps     = 32
nchnls    = 2
0dbfs      = 1.0

garvb        init       0
garvb1      init        0

instr 1

kvol chnget "volume"
kblur chnget "blurAmt"


kdel chnget "ratio"
kdel port kdel, 0.01

asig, asig1 ins
fsig1 pvsanal asig,2048,256,2048,1
fsig2 pvsblur fsig1,kblur*0.75,1
fsig3 pvsblur fsig1,kblur*0.25,1
fsig4 pvsmix fsig2, fsig3
a1 pvsynth fsig4

adel vdelay a1, kdel, 5000

garvb += a1
a1 = asig * kvol
outs a1 + adel, a1 + adel
endin


instr 2

kgain chnget "gain"
kfilt chnget "filt"

kfreezea = p4


asig, asig1 ins

fsig1 pvsanal asig,2048,256,2048,1
fsig4  pvsfreeze fsig1, 0, kfreezea
a1 pvsynth fsig4

a1 moogladder asig, kfilt, 0.8


garvb += a1


outs a1 * kgain, a1 * kgain
endin

instr 3

clear  garvb

endin

instr 100
;kfb chnget "reverb"
;kfb port kfb, .001
arL, arR    reverbsc    garvb, garvb, 0.9, 10000
outs        arL*.3, arR*.3
clear   garvb
endin



</CsInstruments>
<CsScore>

</CsScore>
</CsoundSynthesizer>
