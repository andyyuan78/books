(* Content-type: application/vnd.wolfram.cdf.text *)

(*** Wolfram CDF File ***)
(* http://www.wolfram.com/cdf *)

(* CreatedBy='Mathematica 9.0' *)

(*************************************************************************)
(*                                                                       *)
(*  The Mathematica License under which this file was created prohibits  *)
(*  restricting third parties in receipt of this file from republishing  *)
(*  or redistributing it by any means, including but not limited to      *)
(*  rights management or terms of use, without the express consent of    *)
(*  Wolfram Research, Inc. For additional information concerning CDF     *)
(*  licensing and redistribution see:                                    *)
(*                                                                       *)
(*        www.wolfram.com/cdf/adopting-cdf/licensing-options.html        *)
(*                                                                       *)
(*************************************************************************)

(*CacheID: 234*)
(* Internal cache information:
NotebookFileLineBreakTest
NotebookFileLineBreakTest
NotebookDataPosition[      1063,         20]
NotebookDataLength[    181767,       4086]
NotebookOptionsPosition[    178525,       3959]
NotebookOutlinePosition[    178871,       3974]
CellTagsIndexPosition[    178828,       3971]
WindowFrame->Normal*)

(* Beginning of Notebook Content *)
Notebook[{

Cell[CellGroupData[{
Cell["The Mathematics of Scalping", "Title",
 CellChangeTimes->{{3.609215661895*^9, 3.609215682999*^9}, 3.609215750591*^9}],

Cell["\<\
In this note I want to explore aspects of scalping, a type of strategy widely \
utilized by high frequency trading firms.
I will define a scalping strategy as one in which we seek to take small \
profits by posting limit orders on alternate side of the book. Scalping, as I \
define it, is a strategy rather like market making, except that we \
\[OpenCurlyDoubleQuote]lean\[CloseCurlyDoubleQuote] on one side of the book. \
So, at any given time, we may have a long bias and so look to enter with a \
limit buy order. If this is filled, we will then look to exit with a \
subsequent limit sell order, taking a profit of a few ticks. Conversely, we \
may enter with a limit sell order and look to exit with a limit buy order.
The strategy relies on two critical factors:
(i) the alpha signal which tells us from moment to moment whether we should \
prefer to be long or short
(ii) the execution strategy, or \[OpenCurlyDoubleQuote]trade expression\
\[CloseCurlyDoubleQuote]

I want to focus on the latter, making the assumption that we have some kind \
of alpha generation model already in place (more about this in later posts).
There are several means that a trader can use to enter a position. The \
simplest approach, the one we will be considering here, is simply to place a \
single limit order at or just outside the inside bid/ask prices \[Dash] so in \
other words we will be looking to buy on the bid and sell on the ask (and \
hoping to earn the bid-ask spread, at least).

One of the problems with this approach is that it is highly latency \
sensitive. Limit orders join the limit order book at the back of the queue \
and slowly works their way towards the front, as earlier orders get filled. \
Buy the time the market gets around to your limit buy order, there may be no \
more sellers at that price. In that case the market trades away, a higher bid \
comes in and supersedes your order, and you don\[CloseCurlyQuote]t get \
filled. Conversely, yours may be one of the last orders to get filled, after \
which the market trades down to a lower bid and your position is immediately \
under water.

This simplistic model explains why latency is such a concern \[Dash] you want \
to get as near to the front of the queue as you can, as quickly as possible. \
You do this by minimizing the time it takes to issue and order and get it \
into the limit order book. That entails both hardware (co-located servers, \
fiber-optic connections) and software optimization and typically also \
involves the use of Immediate or Cancel (IOC) orders. The use of IOC orders \
by HFT firms to gain order priority is highly controversial and is seen as \
gaming the system by traditional investors, who may end up paying higher \
prices as a result.
Another approach is to layer limit orders at price points up and down the \
order book, establishing priority long before the market trades there. Order \
layering is a highly complex execution strategy that brings addition \
complications.

Let\[CloseCurlyQuote]s confine ourselves to considering the single limit \
order, the type of order available to any trader using a standard retail \
platform.
As I have explained, we are assuming here that, at any point in time, you \
know whether you prefer to be long or short, and therefore whether you want \
to place a bid or an offer. The issue is, at what price do you place your \
order, and what do you do about limiting your risk? In other words, we are \
discussing profit targets and stop losses, which, of course, are all about \
risk and return.
\
\>", "Text",
 CellChangeTimes->{{3.609215757619*^9, 3.609215759196*^9}, {
  3.6093986814379997`*^9, 3.609398690269*^9}, {3.6093990044519997`*^9, 
  3.609399013877*^9}}],

Cell[CellGroupData[{

Cell["Risk and Return in Scalping", "Subtitle",
 CellChangeTimes->{{3.609399052667*^9, 3.609399078151*^9}}],

Cell["\<\
Lets start by considering risk.The biggest risk to a scalper is that, once \
filled, the market goes against his position until he is obliged to trigger \
his stop loss.If he sets his stop loss too tight, he may be forced to exit \
positions that are initially unprofitable, but which would have recovered and \
shown a profit if he had not exited.Conversely, if he sets the stop loss too \
loose, the risk reward ratio is very low\[Dash]a single loss - making trade \
could eradicate the profit from a large number of smaller, profitable \
trades.Now lets think about reward.If the trader is too ambitious in setting \
his profit target he may never get to realize the gains his position is \
showing\[Dash]the market could reverse, leaving him with a loss on a position \
that was, initially, profitable.Conversely, if he sets the target too tight, \
the trader may give up too much potential in a winning trade to overcome the \
effects of the occasional, large loss.It' s clear that these are critical \
concerns for a scalper : indeed the trade exit rules are just as important, \
or even more important, than the entry rules. So how should he proceed?\
\>", "Text",
 CellChangeTimes->{{3.6093990920290003`*^9, 3.609399110708*^9}, 
   3.6093991494119997`*^9}]
}, Open  ]],

Cell[CellGroupData[{

Cell["Theoretical Framework for Scalping", "Subtitle",
 CellChangeTimes->{{3.609399158633*^9, 3.609399171575*^9}}],

Cell["\<\
Let' s make the rather heroic assumption that market returns are Normally \
distributed (in fact, we know from empirical research that they are \
not\[Dash]but this is a starting point, at least).And let' s assume for the \
moment that our trader has been filled on a limit buy order and is looking to \
decide where to place his profit target and stop loss limit orders.Given a \
current price of the underlying security of X, the scalper is seeking to \
determine the profit target of p ticks and the stop loss level of q ticks \
that will determine the prices at which he should post his limit orders to \
exit the trade.We can translate these into returns, as follows : 

to the upside : Ru = Ln[X + p]\[Dash]Ln[X]

and to the downside : Rd = Ln[X - q]\[Dash]Ln[X]

This situation is illustrated in the chart below.\
\>", "Text",
 CellChangeTimes->{{3.6093992057539997`*^9, 3.609399250789*^9}}],

Cell[CellGroupData[{

Cell[BoxData[{
 RowBox[{
  RowBox[{
   RowBox[{"mu", "=", "0"}], ";", 
   RowBox[{"sigma", "=", "1"}], ";"}], "\[IndentingNewLine]"}], "\n", 
 RowBox[{
  RowBox[{
   RowBox[{"distFn", "=", 
    RowBox[{"PDF", "[", 
     RowBox[{
      RowBox[{"NormalDistribution", "[", 
       RowBox[{"mu", ",", "sigma"}], "]"}], ",", "x"}], "]"}]}], ";"}], 
  "\[IndentingNewLine]"}], "\n", 
 RowBox[{
  RowBox[{"Plot", "[", 
   RowBox[{
    RowBox[{"Evaluate", "[", 
     RowBox[{"distFn", "*", 
      RowBox[{"{", 
       RowBox[{"1", ",", 
        RowBox[{"Boole", "[", 
         RowBox[{
          RowBox[{
           RowBox[{"mu", "+", "sigma"}], "<", "x", "<", 
           RowBox[{"mu", "+", 
            RowBox[{"3", "sigma"}]}]}], " ", "||", " ", 
          RowBox[{
           RowBox[{"mu", "-", 
            RowBox[{"2", "sigma"}]}], ">", "x", ">", 
           RowBox[{"mu", "-", 
            RowBox[{"3", "sigma"}]}]}]}], "]"}]}], "}"}]}], "]"}], ",", 
    RowBox[{"{", 
     RowBox[{"x", ",", 
      RowBox[{"mu", "-", 
       RowBox[{"3", " ", "sigma"}]}], ",", 
      RowBox[{"mu", "+", 
       RowBox[{"3", " ", "sigma"}]}]}], "}"}], ",", 
    RowBox[{"Filling", "\[Rule]", 
     RowBox[{"{", 
      RowBox[{"2", "\[Rule]", "Axis"}], "}"}]}]}], "]"}], 
  "\n"}], "\[IndentingNewLine]"}], "Input",
 CellChangeTimes->{{3.6092396794546003`*^9, 3.6092397034776*^9}, {
  3.6092397797566*^9, 3.6092399005896*^9}, {3.6092399306666*^9, 
  3.6092402208836*^9}, {3.6092405747226*^9, 3.6092405770296*^9}}],

Cell[BoxData[
 GraphicsBox[GraphicsComplexBox[CompressedData["
1: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
Wbl0Uuj736fFU4l4ZEJESVzSiAJvg3LUr4cTkLsD6w7e1IqGzLzmgqcBRCT+
QZH6htVgmLkuE7B4nYTIXtvmr+PgCx6G+ygHbpCRi8O6NxLnXOGYvb6Lr2MP
OltvqM5Ff1/dYZtIlB5qRJscdhNp+2kQdaa0VebKXVRGfs3vOLo/9AWFN4jt
rYL2Ub1kdzv6fsR7/OA6x0o0Ii3YRNGBBncePiQfMk4DsO1/b0Ufr2a12lT4
qAlUacfV1FVpwKv9jb8OIyOHOyJVP045A3vU5o0TW3NQlUDHBUm6n1wt/9gV
K033E6nR8d90P6kIJLtlQA1a1nOUgrtEP5+O7ZYxGIiGz3ZDt0Pp/c0utz1H
+EskykF9Lp5G14kZ8bwBGQ/RyA1I3i/6+T+65r76XE4ODCcamYzR/cSsueu0
1wQZWTY3VsfNO0FRHfuy1od8dJuf4pYp+vlYQlXRxuGpL6wcshjipa/P0YU3
a89/uYNaeHitb6H7w8dw1Cz8wz3oFSlK6KL7yWVjDcT72j20XfHHZzLdT06e
nNRzfxMPM5N792fRx7N2KVitrnqj5r4bREXp84WwaCwafSMjRL/0kaUbTpDk
cfd734AjuIncWadEvz6z5cV0w4MktOqBs6wS/f4Scdw1HunbsHlkOkKc/nyt
z8w/6noEo7Puw/un6XrAx9o+2DgUGglfzlDpOrfl1/b5PXFoqkrBEzW6/iIo
86ZF+ArambRQoUafX1jc9cizFTLy+3Wm+4ymE/xT+T7uPx8G32doBt9naAbf
Z2gG32doBt9naAbfZ2gG32doBt9naAbfZ2gG32doBt9naAbfZ2gG32doBt9n
aAbfZ2gG32doBt9naAbfZ2gG32doBt9naAbfZ2gG32foP/n+fz7/y/f/mXyf
sT44Ctv8/OVff+qAfqv3NP+ZP9ev2dHRes2hz39qrzRFydTbX8CKVbya51Pb
//L4/wePZ+TL/Lwe5ewMM7+n3rGt5kV/+DOfPeu04u6d/vSnfp/MMajJ+wUe
D/32bJps/9fz80pjftc+axxG3iPXu/lrHnAJIF9/vWP6dWlTYy+768c/8/PS
Wlf0sdAceOWb2Ig87fz/joevRx3eRigw81NrNxzGw8+sJ6OJcmmH10z/FRVy
K0nomYO2U6oKIRYd/3p+veFWx1vOMBy2Pqpr650tefCQe0PPRglmPwrpUi44
rTD9TSOD0KtWy/S3/zaP/snaEn0hmRmP9v6XPwc6mP1/Wu4CMekIDlv07v6j
tTEfEn3j+04azoFW5f7lRoPOfzxf/jjnt1ZKj1mfczs1jx2kMs8HKS9snAay
mPW5z0g+dX/ZHOgUHzq/ktnxr+fBWnn5IvKJOOzLRDCupDEXgiIDsK0Isx6O
8fySyKln1qd/WI1Ilh+zPv/bfLfTd4eP3WNmPNGycUfU4pj1GaKpol55BocN
Zh070ns2H2qcvywFKc0BR0kx2Ed1/o3XOnmSL0TNM+erTQ1IMJhjPs8/na9S
w8Mzrl1g1jM7ZXHHq2pmPdfWNyewhTDr+dlicJxA5hx8W0ji29fQ8a/noWMV
CY9VMnCYlqKI4+7YXPikrfx473Hmel92KiMiGcx6vned/8CgOXP9/9t8U0lj
0tX1KTOe0o2ztg4uzHoWPSFNazbFYWeeTL3ulcqHttm0iDSZOTiqV8JzqKDz
b7yyx0hMeAaPw2QkT43lhxeCSFF+0Zph5vP8lS+eOcd3r5eH3u+ep5pldhaC
GcV00SGNOX7Nk5NWwe+Y8c2O/yjtYZ+D0RJRwfk3nf94XnhsMOpDghWzPwRb
TkoUFjD7o0PZSU7Cndkf0UfKOVmS5mDqJMl0uLvjX8/3FJ5Ek/Zn4zABx3rb
2x65ICG3vqL6NHO9XbM4FtfGMvujfKGx/7MBsz7+27zOdmPDtR+dzHiwhOTf
YVbM/rhyWlS63QKHte2tK/vCkQ/9Bd9PyW+ag7RJ2ZLSx51/429hHLp5kUQc
Vt5Vo2jvUwhbt5wByTbm8/yVl319zpJB4cNhHVGjphEbCsGRi/Nm+C3meI1k
hYtrZpnx3SvT2DNIngPtimFCzXTn3/iXybGGNtkl5vi1u34Kzb1nzvd2c9bU
Qd45qDwlqBI20Pk3fvV/R82Brfzn6ptLnYz7MKczI8E77xf+bf6/xvPX/e2v
fsHgY3+9/tf5GJrBDxj6fwDKInLI
   "], {{{}, {}, {}, 
     {Hue[0.9060679774997897, 0.6, 0.6], Opacity[0.2], EdgeForm[None], 
      GraphicsGroupBox[{PolygonBox[CompressedData["
1:eJwV0Ekuw2Ecx+G/Fj2AxFQk9sYDWBlq2HVnXDTpRoJuzBVzLVAO0ETiBjXV
DcxuYOrazAE8Fk/e3+e7fBsTU/HJUBAEJSRZduQNR0xwwK8t5T2kgQGW2LJX
eDsYJ0fRFvG2M8Y+57Z7fqjX/aTJ6AJ3fFNn62ORTX3GLV9Ebb0ssKFfKHe3
Mcoep7YbPqnVMeZZ18+UuVsZIcuJ7ZoPanQPc6zpJ0rdLQyzy7HtineqdTez
rOpHwu5mhtj5/0PbJW9U6S5mWNEPhNxNDLJN3nbBK5W6k2n+APR8NCY=
         "]], PolygonBox[CompressedData["
1:eJwVzjkzHHAcBuDdtAQFH8B91a4UMpMvgHXW6yoYW9CbSISonQXjXHadM7Tu
4wu4SRtXvgAieFI883vfd/7FPz0cCXV8CAQCQbqZU9bZYM0Yd7uI8oUIU6Tx
mXYm+ONtivuJVsY4sv0iKBfSwACrtgeS5TJaGOXQdv3/I3IB9fxkxXZPklxK
MyMc2K54I1+vo59l/Y6PcglNDLNvu+SVPL2WPpb0WxLlYhoZYs92wT9y9Rp+
sKjfkCAXEWaQXds5L+To1fQS13c44y/ZthDfienbnPJMlq2KbyzoW5zwRKat
kh7m9ShzzDLDNFNscswjGd5W8JVJPdUtp41xfttibifv5tFGxw==
         "]]}]}, {}, {}, {}, {}, {}, {}}, {{}, {}, 
     {Hue[0.67, 0.6, 0.6], LineBox[CompressedData["
1:eJwV1He8l2McBuCjvffep72XTUhEUSJEJZKSWSq0QyEls8ys7F00KBVCacoe
ZbSQPbPHdf9xnft+vs95f+e87/t8foVDRvYdsVdBQcHlfiQ7+/GtXMBEjmNv
epuXYr1+K+dSJHtm38lnmEQf9sl15qXZoN/GeRTNntn38lkmczz75jrzMmzU
b+d8imXP7Ae5kCmcwH65zrwsm/Q7uIDi2TP7US7iMvqyf64zL8cb+p1cSIns
mf0kF+cZcCIHUDJp72e5hCs4iQMplbT3i3yOqZzMQZRO2vtVPs80nvSg+smD
KUNZylGeClSkEpWpQlWqUT3X+Kw9cilXcgpdcl/m5dmsz2UENbJn9ptcxlWc
yiG5L/MKvKnfxUhqZs/sd/kCV9OfM8zq8LH+KIfm3q0r8pZ+NxdRK3tmf8jl
TGcAg83q8on+GIfl+VhX4m39npwfvSlf6KM4S2/AtjyvvE+9BV/ptfMZ+p9y
Rf53vTXX6MNlY3bpY2R7BupnynqM49P8DdmWSTye8yWbM4Hd1pfIjkymq3U/
WZmxvJP7lW2YyL05z7IZ4/nS+mLZgdH6UNmQ7fpo2Y6ncuZkS77W69BV/0uu
ZAbnWDfhc/00huj1+Ux/gsPz/q2r8K5+X+6ZYdaN2KE/Td38rvXf8kVmMohu
OQ/mVXlPn5f/m3rZM/tHvsS1nM4R1E/a+1e+zKycD46kAQ1pRGH+R+e8sWxC
U5rRnBa0pFWu81n/yVVcl7NCd1on8wXEK+L6vEOOok0y30+8qt+QZ8PRtE2a
F+E1/cacJXrkLJtV4339/rxj2mXPrCir9ZvyvuiZs2tWnQ/0B7iU9tkzK8Ya
/eY8b45hoFkNPtQfZCwdsmdWnNf12ZzNsXmnZjX5SH+IcXTMnlkJ1upzcqbp
lXdmVost+sOMp1P2zEqyTr8l54beeWdmtdmqP8KE/G3rQnbq88mXfSu+yf3J
Tkyhs/X/71ui0A==
       "]]}, 
     {Hue[0.9060679774997897, 0.6, 0.6], LineBox[CompressedData["
1:eJwNyEkuA3AYxuG/ljqAxFQk9sYDWKGmnZ2pi3YnMWzMxFQsWuoAEokbmN3A
7AbGtbEcwLN48n2/tz410T9eFEJIs+yZioTQTjnv+pJDsnqABiI82laY9ndQ
wYe+4oicHqSRKE+2VWb8nVTyqa85ZlsP0UQxz7Y1Zv0JqvjSN5ywo4dppoQX
2zpz/i6q+da3nJLXI7QQ49WWYd7fTZwffccZGyzYeqihoO85Z5NFWy+1/OoH
LtjVSVop5c22547SRhlbtiW3jzoOmOTPvu+O8Q8BljK7
       "]], LineBox[CompressedData["
1:eJwVzrtRQlEQBuAjkZJhA3BbUDMNJL8S0ICPCJPrSAFoKOIT3wrCjMxgCyI9
gLaALaCp3wm+2f33zOzZZO+gmi2EEFKGuRA2GVBn4uFZrbFOgQ+za3WbFRaZ
mZ3Q0KcUmctTRjQ5pcUZ51xwyVXcR5sbbrnjngceeYp38EKHLq8c+WeLEr/y
F59xl7zDKkv8mPU41ldI+JO/4079PhssM453qLus8cYhefpkvFPmH1WYKRI=

       "]], LineBox[CompressedData["
1:eJwNyiVSgFEYhtEfKhpgAbhlNMAMG8AlowEGAlQCLhkNMLjbBnDZAC4V3wAO
J5y53/vMjatpLW0JCYKgg4XQIGhjhQdx0ttEPjFMa53eIuJ5t8/YYYZZ5phn
gUWW6PK3mAQ+7HN2WaZbKyGRT/uCPVbo0UpJ4su+ZJ9VerUykvm2rzhg2K4h
kzAetTX63OWk8GNfc8iIXUsW4Txp6/S7K0jl177hiFG7jmwieNY2GHBXksaf
fcsxY3Y9OUTyom0y6K4inYA77YRxdwO5RPGqbTHkriaDEO61UybcjeQRzZs2
5W2mgFhmaKWQRdpZZdvffzN2RVg=
       "]]}, 
     {Hue[0.67, 0.6, 0.6], Opacity[0.2], LineBox[{687, 686}], 
      LineBox[{688, 685}]}}, {{}, {}, {}, {}}}],
  AspectRatio->NCache[GoldenRatio^(-1), 0.6180339887498948],
  Axes->True,
  AxesLabel->{None, None},
  AxesOrigin->{0, 0},
  Method->{"AxesInFront" -> True},
  PlotRange->{{-3, 3}, {0., 0.39894223786442035`}},
  PlotRangeClipping->True,
  PlotRangePadding->{
    Scaled[0.02], 
    Scaled[0.02]}]], "Output",
 CellChangeTimes->{{3.6092401770685997`*^9, 3.6092402027206*^9}, 
   3.6092405784606*^9}]
}, Open  ]],

Cell["\<\
The profitable area is the shaded region on the RHS of the distribution. If \
the market trades at this price or higher, we will make money: p ticks, less \
trading fees and commissions, to be precise. Conversely we lose q ticks (plus \
commissions) if the market trades in the region shaded on the LHS of the \
distribution.
Under our assumptions, the probability of ending up in the RHS shaded region \
is:

probWin = 1 \[Dash] NormalCDF(Ru, mu, sigma),
where mu and sigma are the mean and standard deviation of the distribution.

The probability of losing money, i.e. the shaded area in the LHS of the \
distribution, is given by:

probLoss = NormalCDF(Rd, mu, sigma),
where NormalCDF is the cumulative distribution function of the Gaussian \
distribution.

The expected profit from the trade is therefore:
Expected profit = p * probWin \[Dash] q * probLoss

And the expected win rate, the proportion of profitable trades, is given by:
WinRate = probWin / (probWin + probLoss)

If we set a stretch profit target, then p will be large, and probWin, the \
shaded region on the RHS of the distribution, will be small, so our winRate \
will be low. Under this scenario we would have a low probability of a large \
gain. Conversely, if we set p to, say, 1 tick, and our stop loss q to, say, \
20 ticks, the shaded region on the RHS will represent close to half of the \
probability density, while the shaded LHS will encompass only around 5%. Our \
win rate in that case would be of the order of 91%:

WinRate = 50% / (50% + 5%) = 91%

Under this scenario, we make frequent, small profits and suffer the \
occasional large loss.

So the critical question is: how do we pick p and q, our profit target and \
stop loss? Does it matter? What should the decision depend on?
\
\>", "Text",
 CellChangeTimes->{{3.609215847309*^9, 3.609215859212*^9}, {
  3.6092396730976*^9, 3.6092396770486*^9}, {3.6093992746610003`*^9, 
  3.609399306441*^9}}]
}, Open  ]],

Cell[CellGroupData[{

Cell["Modeling Scalping Strategies", "Subtitle",
 CellChangeTimes->{{3.609399347046*^9, 3.609399361218*^9}}],

Cell["\<\
We can begin to address these questions by noticing, as we have already seen, \
that there is a trade - off between the size of profit we are hoping to make, \
and the size of loss we are willing to tolerate, and the probability of that \
gain or loss arising.Those probabilities in turn depend on the underlying \
probability distribution, assumed here to be Gaussian.Now, the Normal or \
Gaussian distribution which determines the probabilities of winning or losing \
at different price levels has two parameters\[Dash]the mean, mu, or drift of \
the returns process and sigma, its volatility.Over short time intervals the \
effect of volatility outweigh any impact from drift by orders of \
magnitude.The reason for this is simple : volatility scales with the square \
root of time, while the drift scales linearly. Over small time intervals, the \
drift becomes un - noticeably small, compared to the process volatility.Hence \
we can assume that mu, the process mean is zero, without concern, and focus \
exclusively on sigma, the volatility.What other factors do we need to \
consider?Well there is a minimum price move, which might be 1 tick, and the \
dollar value of that tick, from which we can derive our upside and downside \
returns, Ru and Rd.And, finally, we need to factor in commissions and \
exchange fees into our net trade P & L.

Here' s a simple formulation of the model, in which I am using the E - mini \
futures contract as an exemplar.\
\>", "Text",
 CellChangeTimes->{{3.609399372506*^9, 3.609399393519*^9}}],

Cell[BoxData[
 RowBox[{
  RowBox[{
   RowBox[{"WinRate", "[", 
    RowBox[{
    "currentPrice_", ",", "annualVolatility_", ",", "BarSizeMins_", ",", " ", 
     "nTicksPT_", ",", " ", "nTicksSL_", ",", "minMove_", ",", " ", 
     "tickValue_", ",", " ", "costContract_"}], "]"}], ":=", 
   RowBox[{"Module", "[", 
    RowBox[{
     RowBox[{"{", " ", 
      RowBox[{
      "nMinsPerDay", ",", " ", "periodVolatility", ",", " ", "tgtReturn", ",",
        " ", "slReturn", ",", "tgtDollar", ",", " ", "slDollar", ",", " ", 
       "probWin", ",", " ", "probLoss", ",", " ", "winRate", ",", " ", 
       "expWinDollar", ",", " ", "expLossDollar", ",", " ", "expProfit"}], 
      "}"}], ",", " ", "\n", 
     RowBox[{
      RowBox[{"nMinsPerDay", " ", "=", " ", 
       RowBox[{"250", "*", "6.5", "*", "60"}]}], ";", "\n", 
      RowBox[{"periodVolatility", " ", "=", " ", 
       RowBox[{"annualVolatility", " ", "/", " ", 
        RowBox[{"Sqrt", "[", 
         RowBox[{"nMinsPerDay", "/", "BarSizeMins"}], "]"}]}]}], ";", "\n", 
      RowBox[{"tgtReturn", "=", 
       RowBox[{"nTicksPT", "*", 
        RowBox[{"minMove", "/", "currentPrice"}]}]}], ";", 
      RowBox[{"tgtDollar", " ", "=", " ", 
       RowBox[{"nTicksPT", " ", "*", " ", "tickValue"}]}], ";", 
      "\[IndentingNewLine]", 
      RowBox[{"slReturn", " ", "=", " ", 
       RowBox[{"nTicksSL", "*", 
        RowBox[{"minMove", "/", "currentPrice"}]}]}], ";", 
      "\[IndentingNewLine]", 
      RowBox[{"slDollar", "=", 
       RowBox[{"nTicksSL", "*", "tickValue"}]}], ";", "\[IndentingNewLine]", 
      RowBox[{"probWin", "=", 
       RowBox[{"1", "-", 
        RowBox[{"CDF", "[", 
         RowBox[{
          RowBox[{"NormalDistribution", "[", 
           RowBox[{"0", ",", " ", "periodVolatility"}], "]"}], ",", 
          "tgtReturn"}], "]"}]}]}], ";", "\[IndentingNewLine]", 
      RowBox[{"probLoss", "=", 
       RowBox[{"CDF", "[", 
        RowBox[{
         RowBox[{"NormalDistribution", "[", 
          RowBox[{"0", ",", " ", "periodVolatility"}], "]"}], ",", 
         "slReturn"}], "]"}]}], ";", "\[IndentingNewLine]", 
      RowBox[{"winRate", "=", 
       RowBox[{"probWin", "/", 
        RowBox[{"(", 
         RowBox[{"probWin", "+", "probLoss"}], ")"}]}]}], ";", 
      "\[IndentingNewLine]", 
      RowBox[{"expWinDollar", "=", 
       RowBox[{"tgtDollar", "*", "probWin"}]}], ";", "\[IndentingNewLine]", 
      RowBox[{"expLossDollar", "=", 
       RowBox[{"slDollar", "*", "probLoss"}]}], ";", "\[IndentingNewLine]", 
      RowBox[{"expProfit", "=", 
       RowBox[{"expWinDollar", "+", "expLossDollar", "-", "costContract"}]}], 
      ";", "\[IndentingNewLine]", 
      RowBox[{"{", 
       RowBox[{"expProfit", ",", " ", "winRate"}], "}"}]}]}], "]"}]}], 
  "\[IndentingNewLine]", "\[IndentingNewLine]"}]], "Input",
 CellChangeTimes->{{3.609216394658*^9, 3.609216394671*^9}, 
   3.609216454811*^9, {3.609216542434*^9, 3.60921661399*^9}, {
   3.609216645949*^9, 3.609216945363*^9}, {3.609216999615*^9, 
   3.609217222101*^9}, {3.60921728034*^9, 3.6092172939040003`*^9}, 
   3.609218149778*^9}],

Cell["\<\
The function returns two outputs :  the expected P & L per contract and the \
expected Win Rate :.  For the ES contract we have a min price move of 0.25 \
and the tick value is $12.50. Notice that we scale annual volatility to the \
size of the period we are trading (15 minute bars, in the following example).
\
\>", "Text",
 CellChangeTimes->{{3.6093994073120003`*^9, 3.6093994746470003`*^9}}],

Cell[CellGroupData[{

Cell[BoxData[
 RowBox[{"WinRate", "[", 
  RowBox[{"1900", ",", "0.1", ",", "15", ",", "1", ",", 
   RowBox[{"-", "24"}], ",", "0.25", ",", "12.50", ",", "3"}], "]"}]], "Input",
 CellChangeTimes->{{3.609216463625*^9, 3.609216505778*^9}, {3.609217228836*^9,
    3.609217267899*^9}, 3.6092173075360003`*^9, 3.609217356049*^9, {
   3.60921741602*^9, 3.609217419771*^9}, {3.609217455304*^9, 
   3.609217478276*^9}}],

Cell[BoxData[
 RowBox[{"{", 
  RowBox[{"1.0873918080522458`", ",", "0.9882371590352066`"}], 
  "}"}]], "Output",
 CellChangeTimes->{
  3.609216505896*^9, {3.6092172630889997`*^9, 3.6092173082530003`*^9}, 
   3.609217356584*^9, {3.609217417435*^9, 3.609217420579*^9}, {
   3.609217456032*^9, 3.6092174794560003`*^9}, 3.609218190816*^9, 
   3.6092325496506*^9, 3.6092338876456003`*^9}]
}, Open  ]]
}, Open  ]],

Cell[CellGroupData[{

Cell["Scenario Analysis", "Subtitle",
 CellChangeTimes->{{3.609399488211*^9, 3.6093995191070004`*^9}}],

Cell["\<\
Let' s take a look at how the expected profit and win rate vary with the \
profit target and stop loss limits we set. In the following interactive \
graphics, we can assess the impact of different levels of volatility on the \
outcome.\
\>", "Text",
 CellChangeTimes->{{3.6093995225810003`*^9, 3.6093995415290003`*^9}, {
  3.609400440483*^9, 3.609400442083*^9}}],

Cell[CellGroupData[{

Cell[BoxData[
 RowBox[{"Manipulate", "[", 
  RowBox[{
   RowBox[{"Plot3D", "[", 
    RowBox[{
     RowBox[{
      RowBox[{"WinRate", "[", 
       RowBox[{
       "1900", ",", "Volatility", ",", "BarSizeMins", ",", "nTicksPT", ",", 
        "nTicksSL", ",", "0.25", ",", "12.50", ",", "3"}], "]"}], "[", 
      RowBox[{"[", "1", "]"}], "]"}], ",", 
     RowBox[{"{", 
      RowBox[{"nTicksPT", ",", "1", ",", "30"}], "}"}], ",", 
     RowBox[{"{", 
      RowBox[{"nTicksSL", ",", 
       RowBox[{"-", "1"}], ",", 
       RowBox[{"-", "30"}]}], "}"}], ",", 
     RowBox[{"PlotLabel", "\[Rule]", 
      RowBox[{"Style", "[", 
       RowBox[{"\"\<Expected Profit by Bar Size and Volatility\>\"", ",", " ", 
        RowBox[{"FontSize", "\[Rule]", "18"}]}], "]"}]}], " ", ",", 
     RowBox[{"AxesLabel", "->", 
      RowBox[{"{", 
       RowBox[{
       "\"\<Profit Target (ticks)\>\"", ",", " ", "\"\<Stop Loss (ticks)\>\"",
         ",", " ", "\"\<Exp. Profit $\>\""}], "}"}]}], ",", " ", 
     RowBox[{"ImageSize", "\[Rule]", "Large"}]}], "]"}], ",", 
   RowBox[{"{", 
    RowBox[{"BarSizeMins", ",", 
     RowBox[{"{", 
      RowBox[{"1", ",", "3", ",", "5", ",", "10", ",", "15", ",", "30"}], 
      "}"}]}], "}"}], ",", 
   RowBox[{"{", 
    RowBox[{"Volatility", ",", "0.05", ",", "0.5"}], "}"}], ",", 
   RowBox[{"Initialization", "\[Rule]", 
    RowBox[{"(", 
     RowBox[{
      RowBox[{"BarSizeMins", ":=", "3"}], ";", " ", 
      RowBox[{"Volatility", ":=", "0.1"}]}], ")"}]}], ",", 
   RowBox[{"SaveDefinitions", "->", "True"}]}], "]"}]], "Input",
 CellChangeTimes->{{3.609216468752*^9, 3.609216470182*^9}, {3.609217520447*^9,
    3.609217604943*^9}, {3.609217655238*^9, 3.609217655771*^9}, {
   3.609217719065*^9, 3.609217743307*^9}, {3.609217829574*^9, 
   3.609217830421*^9}, {3.6092178852609997`*^9, 3.609217916406*^9}, {
   3.60921801577*^9, 3.6092180599440002`*^9}, {3.6092180905769997`*^9, 
   3.60921809112*^9}, {3.6092182261359997`*^9, 3.6092183135360003`*^9}, {
   3.609218347572*^9, 3.6092183760699997`*^9}, {3.609218445571*^9, 
   3.6092184625620003`*^9}, {3.609218621957*^9, 3.609218635164*^9}, {
   3.609218732116*^9, 3.6092187489370003`*^9}, {3.609218822211*^9, 
   3.609218877525*^9}, {3.609218921321*^9, 3.609218926271*^9}, {
   3.609218995487*^9, 3.609219036843*^9}, {3.609219201856*^9, 
   3.6092192106470003`*^9}, {3.609219251494*^9, 3.609219252303*^9}, {
   3.6092338791935997`*^9, 3.6092338794526*^9}, {3.609294868387*^9, 
   3.609294906047*^9}, {3.6092949443459997`*^9, 3.609294973723*^9}, 
   3.6092952112130003`*^9, {3.609295847914*^9, 3.609295867137*^9}, {
   3.609296395974*^9, 3.60929639991*^9}, {3.609296438006*^9, 
   3.609296438356*^9}, {3.6092964720889997`*^9, 3.609296475638*^9}, {
   3.609296732664*^9, 3.609296761591*^9}, {3.609399547244*^9, 
   3.609399587701*^9}, {3.609399748417*^9, 3.609399750558*^9}, {
   3.609399826719*^9, 3.60939985451*^9}, {3.609399894207*^9, 
   3.6093999315959997`*^9}, 3.609400000071*^9, {3.609400216126*^9, 
   3.609400267564*^9}, {3.609400354822*^9, 3.6094003848459997`*^9}, {
   3.609400564498*^9, 3.60940056676*^9}, {3.609404680441*^9, 
   3.609404688993*^9}}],

Cell[BoxData[
 TagBox[
  StyleBox[
   DynamicModuleBox[{$CellContext`BarSizeMins$$ = 
    3, $CellContext`Volatility$$ = 0.1, Typeset`show$$ = True, 
    Typeset`bookmarkList$$ = {}, Typeset`bookmarkMode$$ = "Menu", 
    Typeset`animator$$, Typeset`animvar$$ = 1, Typeset`name$$ = 
    "\"untitled\"", Typeset`specs$$ = {{
      Hold[$CellContext`BarSizeMins$$], {1, 3, 5, 10, 15, 30}}, {
      Hold[$CellContext`Volatility$$], 0.05, 0.5}}, Typeset`size$$ = {
    576., {211., 215.}}, Typeset`update$$ = 0, Typeset`initDone$$, 
    Typeset`skipInitDone$$ = False, $CellContext`BarSizeMins$939749$$ = 
    0, $CellContext`Volatility$939750$$ = 0}, 
    DynamicBox[Manipulate`ManipulateBoxes[
     1, StandardForm, 
      "Variables" :> {$CellContext`BarSizeMins$$ = 
        1, $CellContext`Volatility$$ = 0.05}, "ControllerVariables" :> {
        Hold[$CellContext`BarSizeMins$$, $CellContext`BarSizeMins$939749$$, 
         0], 
        Hold[$CellContext`Volatility$$, $CellContext`Volatility$939750$$, 0]},
       "OtherVariables" :> {
       Typeset`show$$, Typeset`bookmarkList$$, Typeset`bookmarkMode$$, 
        Typeset`animator$$, Typeset`animvar$$, Typeset`name$$, 
        Typeset`specs$$, Typeset`size$$, Typeset`update$$, Typeset`initDone$$,
         Typeset`skipInitDone$$}, "Body" :> Plot3D[
        Part[
         $CellContext`WinRate[
         1900, $CellContext`Volatility$$, $CellContext`BarSizeMins$$, \
$CellContext`nTicksPT, $CellContext`nTicksSL, 0.25, 12.5, 3], 
         1], {$CellContext`nTicksPT, 1, 30}, {$CellContext`nTicksSL, -1, -30},
         PlotLabel -> 
        Style["Expected Profit by Bar Size and Volatility", FontSize -> 18], 
        AxesLabel -> {
         "Profit Target (ticks)", "Stop Loss (ticks)", "Exp. Profit $"}, 
        ImageSize -> Large], 
      "Specifications" :> {{$CellContext`BarSizeMins$$, {1, 3, 5, 10, 15, 
         30}}, {$CellContext`Volatility$$, 0.05, 0.5}}, "Options" :> {}, 
      "DefaultOptions" :> {}],
     ImageSizeCache->{627., {272., 277.}},
     SingleEvaluation->True],
    Deinitialization:>None,
    DynamicModuleValues:>{},
    Initialization:>({{$CellContext`WinRate[
           Pattern[$CellContext`currentPrice, 
            Blank[]], 
           Pattern[$CellContext`annualVolatility, 
            Blank[]], 
           Pattern[$CellContext`BarSizeMins, 
            Blank[]], 
           Pattern[$CellContext`nTicksPT, 
            Blank[]], 
           Pattern[$CellContext`nTicksSL, 
            Blank[]], 
           Pattern[$CellContext`minMove, 
            Blank[]], 
           Pattern[$CellContext`tickValue, 
            Blank[]], 
           Pattern[$CellContext`costContract, 
            Blank[]]] := 
         Module[{$CellContext`nMinsPerDay, $CellContext`periodVolatility, \
$CellContext`tgtReturn, $CellContext`slReturn, $CellContext`tgtDollar, \
$CellContext`slDollar, $CellContext`probWin, $CellContext`probLoss, \
$CellContext`winRate, $CellContext`expWinDollar, $CellContext`expLossDollar, \
$CellContext`expProfit}, $CellContext`nMinsPerDay = (250 6.5) 
             60; $CellContext`periodVolatility = \
$CellContext`annualVolatility/
             Sqrt[$CellContext`nMinsPerDay/$CellContext`BarSizeMins]; \
$CellContext`tgtReturn = $CellContext`nTicksPT \
($CellContext`minMove/$CellContext`currentPrice); $CellContext`tgtDollar = \
$CellContext`nTicksPT $CellContext`tickValue; $CellContext`slReturn = \
$CellContext`nTicksSL ($CellContext`minMove/$CellContext`currentPrice); \
$CellContext`slDollar = $CellContext`nTicksSL $CellContext`tickValue; \
$CellContext`probWin = 1 - CDF[
              NormalDistribution[
              0, $CellContext`periodVolatility], $CellContext`tgtReturn]; \
$CellContext`probLoss = CDF[
              NormalDistribution[
              0, $CellContext`periodVolatility], $CellContext`slReturn]; \
$CellContext`winRate = $CellContext`probWin/($CellContext`probWin + \
$CellContext`probLoss); $CellContext`expWinDollar = $CellContext`tgtDollar \
$CellContext`probWin; $CellContext`expLossDollar = $CellContext`slDollar \
$CellContext`probLoss; $CellContext`expProfit = $CellContext`expWinDollar + \
$CellContext`expLossDollar - $CellContext`costContract; \
{$CellContext`expProfit, $CellContext`winRate}], $CellContext`BarSizeMins$$ := 
         3, $CellContext`nTicksPT := 
         2, $CellContext`nTicksSL := -6, $CellContext`Volatility$$ := 0.1}; 
       Null}; Typeset`initDone$$ = True),
    SynchronousInitialization->True,
    UnsavedVariables:>{Typeset`initDone$$},
    UntrackedVariables:>{Typeset`size$$}], "Manipulate",
   Deployed->True,
   StripOnInput->False],
  Manipulate`InterpretManipulate[1]]], "Output",
 CellChangeTimes->{
  3.609400001736*^9, {3.6094002617799997`*^9, 3.6094002762609997`*^9}, {
   3.609400375792*^9, 3.609400385277*^9}, 3.609400567691*^9, {
   3.609404682023*^9, 3.609404689517*^9}}]
}, Open  ]],

Cell[CellGroupData[{

Cell[BoxData[
 RowBox[{"Manipulate", "[", 
  RowBox[{
   RowBox[{"Plot3D", "[", 
    RowBox[{
     RowBox[{
      RowBox[{"WinRate", "[", 
       RowBox[{
       "1900", ",", "Volatility", ",", "BarSizeMins", ",", "nTicksPT", ",", 
        "nTicksSL", ",", "0.25", ",", "12.50", ",", "3"}], "]"}], "[", 
      RowBox[{"[", "2", "]"}], "]"}], ",", 
     RowBox[{"{", 
      RowBox[{"nTicksPT", ",", "1", ",", "30"}], "}"}], ",", 
     RowBox[{"{", 
      RowBox[{"nTicksSL", ",", 
       RowBox[{"-", "1"}], ",", 
       RowBox[{"-", "30"}]}], "}"}], ",", 
     RowBox[{"PlotLabel", "\[Rule]", 
      RowBox[{"Style", "[", 
       RowBox[{"\"\<Expected Win Rate by Volatility\>\"", ",", " ", 
        RowBox[{"FontSize", "\[Rule]", "18"}]}], "]"}]}], ",", 
     RowBox[{"AxesLabel", "->", 
      RowBox[{"{", 
       RowBox[{
       "\"\<Profit Target (ticks)\>\"", ",", " ", "\"\<Stop Loss (ticks)\>\"",
         ",", " ", "\"\<Exp. Win Rate (%)\n\>\""}], "}"}]}], ",", 
     RowBox[{"ImageSize", "\[Rule]", "Large"}]}], "]"}], ",", 
   RowBox[{"{", 
    RowBox[{"BarSizeMins", ",", 
     RowBox[{"{", 
      RowBox[{"1", ",", "3", ",", "5", ",", "10", ",", "15", ",", "30"}], 
      "}"}]}], "}"}], ",", 
   RowBox[{"{", 
    RowBox[{"Volatility", ",", "0.05", ",", "0.5"}], "}"}], ",", 
   RowBox[{"Initialization", "\[Rule]", 
    RowBox[{"(", 
     RowBox[{
      RowBox[{"BarSizeMins", ":=", "3"}], ";", " ", 
      RowBox[{"Volatility", ":=", "0.1"}]}], ")"}]}], ",", 
   RowBox[{"SaveDefinitions", "->", "True"}]}], "]"}]], "Input",
 CellChangeTimes->{{3.609218884693*^9, 3.6092188848269997`*^9}, {
   3.6092189172209997`*^9, 3.609218917336*^9}, {3.609219080127*^9, 
   3.609219129638*^9}, {3.609219262217*^9, 3.6092192738120003`*^9}, {
   3.6092338836436*^9, 3.6092338839396*^9}, 3.609296596507*^9, {
   3.609296629385*^9, 3.6092966314969997`*^9}, {3.609296783947*^9, 
   3.609296785284*^9}, {3.6094004278310003`*^9, 3.609400429623*^9}, {
   3.6094004696949997`*^9, 3.609400487844*^9}, {3.6094006592019997`*^9, 
   3.609400714017*^9}}],

Cell[BoxData[
 TagBox[
  StyleBox[
   DynamicModuleBox[{$CellContext`BarSizeMins$$ = 
    3, $CellContext`Volatility$$ = 0.1, Typeset`show$$ = True, 
    Typeset`bookmarkList$$ = {}, Typeset`bookmarkMode$$ = "Menu", 
    Typeset`animator$$, Typeset`animvar$$ = 1, Typeset`name$$ = 
    "\"untitled\"", Typeset`specs$$ = {{
      Hold[$CellContext`BarSizeMins$$], {1, 3, 5, 10, 15, 30}}, {
      Hold[$CellContext`Volatility$$], 0.05, 0.5}}, Typeset`size$$ = {
    576., {199., 204.}}, Typeset`update$$ = 0, Typeset`initDone$$, 
    Typeset`skipInitDone$$ = False, $CellContext`BarSizeMins$712122$$ = 
    0, $CellContext`Volatility$712123$$ = 0}, 
    DynamicBox[Manipulate`ManipulateBoxes[
     1, StandardForm, 
      "Variables" :> {$CellContext`BarSizeMins$$ = 
        1, $CellContext`Volatility$$ = 0.05}, "ControllerVariables" :> {
        Hold[$CellContext`BarSizeMins$$, $CellContext`BarSizeMins$712122$$, 
         0], 
        Hold[$CellContext`Volatility$$, $CellContext`Volatility$712123$$, 0]},
       "OtherVariables" :> {
       Typeset`show$$, Typeset`bookmarkList$$, Typeset`bookmarkMode$$, 
        Typeset`animator$$, Typeset`animvar$$, Typeset`name$$, 
        Typeset`specs$$, Typeset`size$$, Typeset`update$$, Typeset`initDone$$,
         Typeset`skipInitDone$$}, "Body" :> Plot3D[
        Part[
         $CellContext`WinRate[
         1900, $CellContext`Volatility$$, $CellContext`BarSizeMins$$, \
$CellContext`nTicksPT, $CellContext`nTicksSL, 0.25, 12.5, 3], 
         2], {$CellContext`nTicksPT, 1, 30}, {$CellContext`nTicksSL, -1, -30},
         PlotLabel -> 
        Style["Expected Win Rate by Volatility", FontSize -> 18], 
        AxesLabel -> {
         "Profit Target (ticks)", "Stop Loss (ticks)", "Exp. Win Rate (%)\n"},
         ImageSize -> Large], 
      "Specifications" :> {{$CellContext`BarSizeMins$$, {1, 3, 5, 10, 15, 
         30}}, {$CellContext`Volatility$$, 0.05, 0.5}}, "Options" :> {}, 
      "DefaultOptions" :> {}],
     ImageSizeCache->{627., {261., 266.}},
     SingleEvaluation->True],
    Deinitialization:>None,
    DynamicModuleValues:>{},
    Initialization:>({{$CellContext`WinRate[
           Pattern[$CellContext`currentPrice, 
            Blank[]], 
           Pattern[$CellContext`annualVolatility, 
            Blank[]], 
           Pattern[$CellContext`BarSizeMins, 
            Blank[]], 
           Pattern[$CellContext`nTicksPT, 
            Blank[]], 
           Pattern[$CellContext`nTicksSL, 
            Blank[]], 
           Pattern[$CellContext`minMove, 
            Blank[]], 
           Pattern[$CellContext`tickValue, 
            Blank[]], 
           Pattern[$CellContext`costContract, 
            Blank[]]] := 
         Module[{$CellContext`nMinsPerDay, $CellContext`periodVolatility, \
$CellContext`tgtReturn, $CellContext`slReturn, $CellContext`tgtDollar, \
$CellContext`slDollar, $CellContext`probWin, $CellContext`probLoss, \
$CellContext`winRate, $CellContext`expWinDollar, $CellContext`expLossDollar, \
$CellContext`expProfit}, $CellContext`nMinsPerDay = (250 6.5) 
             60; $CellContext`periodVolatility = \
$CellContext`annualVolatility/
             Sqrt[$CellContext`nMinsPerDay/$CellContext`BarSizeMins]; \
$CellContext`tgtReturn = $CellContext`nTicksPT \
($CellContext`minMove/$CellContext`currentPrice); $CellContext`tgtDollar = \
$CellContext`nTicksPT $CellContext`tickValue; $CellContext`slReturn = \
$CellContext`nTicksSL ($CellContext`minMove/$CellContext`currentPrice); \
$CellContext`slDollar = $CellContext`nTicksSL $CellContext`tickValue; \
$CellContext`probWin = 1 - CDF[
              NormalDistribution[
              0, $CellContext`periodVolatility], $CellContext`tgtReturn]; \
$CellContext`probLoss = CDF[
              NormalDistribution[
              0, $CellContext`periodVolatility], $CellContext`slReturn]; \
$CellContext`winRate = $CellContext`probWin/($CellContext`probWin + \
$CellContext`probLoss); $CellContext`expWinDollar = $CellContext`tgtDollar \
$CellContext`probWin; $CellContext`expLossDollar = $CellContext`slDollar \
$CellContext`probLoss; $CellContext`expProfit = $CellContext`expWinDollar + \
$CellContext`expLossDollar - $CellContext`costContract; \
{$CellContext`expProfit, $CellContext`winRate}], $CellContext`BarSizeMins$$ := 
         3, $CellContext`Volatility$$ := 0.1}; Null}; 
     Typeset`initDone$$ = True),
    SynchronousInitialization->True,
    UnsavedVariables:>{Typeset`initDone$$},
    UntrackedVariables:>{Typeset`size$$}], "Manipulate",
   Deployed->True,
   StripOnInput->False],
  Manipulate`InterpretManipulate[1]]], "Output",
 CellChangeTimes->{3.609400715699*^9}]
}, Open  ]],

Cell["\<\
Notice to begin with that the win rate (and expected profit) are very far \
from being Normally distributed\[Dash]not least because they change radically \
with volatility, which is itself time - varying.For very low levels of \
volatility, around 5 %, we appear to do best in terms of maximizing our \
expected P & L by setting a tight profit target of a couple of ticks, and a \
stop loss of around 10 ticks.Our win rate is very high at these levels - \
around 90 % or more.In other words, at low levels of volatility, our aim \
should be to try to make a large number of small gains.But as volatility \
increases to around 15 %, it becomes evident that we need to increase our \
profit target, to around 10 or 11 ticks.T

he distribution of the expected P & L suggests we have a couple of different \
strategy options : either we can set a larger stop loss, of around 30 ticks, \
or we can head in the other direction, and set a very low stop loss of \
perhaps just 1 - 2 ticks.This later strategy is, in fact, the mirror image of \
our low - volatility strategy : at higher levels of volatility, we are aiming \
to make occasional, large gains and we are willing to pay the price of \
sustaining repeated small stop - losses.Our win rate, although still well \
above 50 %, naturally declines.As volatility rises still further, to 20 % or \
30 %, or more, it becomes apparent that we really have no alternative but to \
aim for occasional large gains, by increasing our profit target and \
tightening stop loss limits.Our win rate under this strategy scenario will be \
much lower\[Dash]around 30 % or less.\
\>", "Text",
 CellChangeTimes->{{3.6094015897650003`*^9, 3.609401611133*^9}}]
}, Open  ]],

Cell[CellGroupData[{

Cell["Non - Gaussian Model", "Subtitle",
 CellChangeTimes->{{3.609400954459*^9, 3.609400972759*^9}}],

Cell["\<\
Now let\[CloseCurlyQuote]s address the concern that asset returns are not \
typically distributed Normally.  In particular, the empirical distribution of \
returns tends to have \[OpenCurlyDoubleQuote]fat \
tails\[CloseCurlyDoubleQuote], i.e. the probability of an extreme event is \
much higher than in an equivalent Normal distribution.

A widely used model for fat-tailed distributions in the Extreme Value \
Distribution.  This has pdf:\
\>", "Text",
 CellChangeTimes->{{3.609400845428*^9, 3.6094010530039997`*^9}, {
  3.609401159058*^9, 3.609401163283*^9}, {3.609475554737*^9, 
  3.609475554874*^9}}],

Cell[BoxData[
 RowBox[{"PDF", "[", 
  RowBox[{
   RowBox[{"ExtremeValueDistribution", "[", 
    RowBox[{"\[Alpha]", ",", "\[Beta]"}], "]"}], ",", "x"}], "]"}]], "Input",
 CellChangeTimes->{{3.6093034981940002`*^9, 3.6093034981949997`*^9}}],

Cell[BoxData[
 FormBox[
  StyleBox[
   FractionBox[
    SuperscriptBox["\[ExponentialE]", 
     RowBox[{
      FractionBox[
       RowBox[{"\[Alpha]", "-", "x"}], "\[Beta]"], "-", 
      SuperscriptBox["\[ExponentialE]", 
       FractionBox[
        RowBox[{"\[Alpha]", "-", "x"}], "\[Beta]"]]}]], "\[Beta]"], 
   "Subtitle"], TraditionalForm]], "Input",
 CellChangeTimes->{3.609303607957*^9}],

Cell[CellGroupData[{

Cell[BoxData[
 RowBox[{"Plot", "[", 
  RowBox[{
   RowBox[{"Evaluate", "@", 
    RowBox[{"Table", "[", 
     RowBox[{
      RowBox[{"PDF", "[", 
       RowBox[{
        RowBox[{"ExtremeValueDistribution", "[", 
         RowBox[{"\[Alpha]", ",", "2"}], "]"}], ",", "x"}], "]"}], ",", 
      RowBox[{"{", 
       RowBox[{"\[Alpha]", ",", 
        RowBox[{"{", 
         RowBox[{
          RowBox[{"-", "3"}], ",", "0", ",", "4"}], "}"}]}], "}"}]}], "]"}]}],
    ",", 
   RowBox[{"{", 
    RowBox[{"x", ",", 
     RowBox[{"-", "8"}], ",", "12"}], "}"}], ",", 
   RowBox[{"Filling", "\[Rule]", "Axis"}]}], "]"}]], "Input",
 CellID->230444506],

Cell[BoxData[
 GraphicsBox[GraphicsComplexBox[CompressedData["
1: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
2t9cnw/C+rWqmcmDwmr+WL/2F//9KM+MF9avWfurWJ6ed8X6td5fl7mqp5yw
fi3C40jVh+yLWL/G8v1a4ilRG6xXI98/5F5t54mpasamFp7cq1EQPsmy7r/C
k3s129Wd8f8G5ZDW8stuZzh4YOH8ydFk61uIz5opBYUPFxRoRwdlx94iWxon
HbzbOCBjDK9PcCQ91rc5iHyK1BxUw/q2az9eDrMJ2mB9m2trbbXdl2Csb/tA
FRP/kC8Z69ssnxfbKvEUgZT0PipNs1+EK8bnHf+ZtIN5HR/V0uwVQuNBV3Zn
8S6Q3VBYP005Tbj4wkTl6pduMOfQ3JrLVE64rfwLPUiab+m+77N6xYyD8zeK
aa9IELE+LqWbM3U71grr3/jq/VgFlLjx5P6Ne/3qobNU9/Hk/s1oYn2maIwN
eRTTX6kfxgNtpV45m5n6Iz2HZ8y9J7ngmaoGUT7bVkTz6MORj9Kc0LtO31IE
2UYScvs+vb/BDmfNtItN/x0GxFltDopFVqgHOIxSdM9iPZ1b0Nbkj/t+WE93
UHibVfFZHPCesvDJ+fODcCggZ789qhPQHL3jIFo9S0hMYDlplNUNHH6tZ61v
thN2DTerPEjrSQT6BDa8GQRRlpk6++eIWE9nXh0+XAkc8A7NN2KG1/gg0TSt
1yNqAr+0lfp3V58X2nFo3Ljppov0EnekrGu5IWw1oxv5chdhb35Zk0nBRZoX
Rp72yk4jTcenV/bOcECbHamweVtO0FzzsPTyCzbIXTe6+tsZAHG0t6HmICuU
MLM5vzTliPV7h9fkc5ecIoDoP5GSsLoxQpt10KGH0kTwKV7ex3i2HgT/G9vj
Ja23afdMHcXx/wGeCwtiH792Yz1fupRpcp25JdbrzdgY3yVIUePPZPzuP7yC
g7TWGtNujul456eeAaHn+aDpM7benmZq5ME6VU9nNQ88t/2Oi07ZFQkhykSI
sXNDfTqqo7iEBmRcdSolzZ4Teh3Z/ltpv4Foc4xcWW5kh34ZsmYNcZJAKcnm
kYUQG6SW9RtfcTYGQU6bxNz3bwgdSjbRLV5E4DvCoVzz8S3QqXa8k+FKxHpA
8vNG7gHNDBkbd/1M8WmRb7ueiONgg2+b4r/Zt/j+pR+63FG8UHp7p2aFQhPp
UFc+PTLDDQc1w+zi61MQaEH3wUCDC7LiY97wFowgFsdYK57GccC4vLLiYeZD
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
6i4XEA==
   "], {{{}, 
     {Hue[0.67, 0.6, 0.6], Opacity[0.2], EdgeForm[None], 
      GraphicsGroupBox[PolygonBox[CompressedData["
1:eJwl1WWYVVUUBuA71IiUYqCUgHRJo6TYSg9tAWPQMzQoNUqpCNJKdzeolIBS
IiDdgoDd3f2uxx/vs761zo0ze599p2hqekpapkQikcSnSf/XYcmJRAZV5I8N
MrjAzQzgBIddy6s+yS5e1O8gk9yaDbTTZ7CBX3jAbAmV5bbxPaznZ+43X0wl
uQ1DWcdP3Ge+iFvk1gxhLT9yr/lCKsqtGMwafuAe8wVUkFsyiNV8z93m8ykv
t+BpVvEdd5nPo5ycwlOs5FvuNJ9LWbk5A1nBN9xhPocycjMGsJyvaWA+m9Jy
U/qzjK+43XwWpeQm9GMpX1LffCYl5cb0ZQlfUM98BiXkRvRhMZ9T13w6xeWG
9GYRn1HHfFrsZ+wJvVgY+09t81coFntCTxbwCbXMX6Zo7AnpzI9nhNvMp1Ik
9oQ05vERt5pP4abYE3owlw+paT6ZwrEndGcOH1DDfBKFYk/oxmwuU918IgVj
T+jKLC5RzXwCBWJP6MJMLlLVfDz55Ru5gXxcz3VcyzXk5erYNzozg/ep4r0v
cVXsG52YzgUqm48jjzyG7STpW7Ge+vp95JDb80acH/00zlNJP5bccjG1P8c5
FPeiPsFOXtAXVHvyLtvi+VVPx+GlJeuoF+uvDuW9WH8u04cjvB3rrA7iDFdy
kUfZGt8Xe6QO4Rz5uEQ39sVzEmdDPRWfH+sTZzR+C8ilH6aej+eFfhyL+zUf
rJ6NNeRx3uJ58wJqOgdjbfT/0kJeS115L9nlR9gS7419U7vG3xLPpv4cFeUx
5JQPkkd+jDd5Tr+Vf0jRr6GOvIcr5IfZHK/XT+UsFWLNySGPZgt/09xsNbXl
VKZwhvLx98R6yqPYzF80M1tFLbkjkzlNubgvssc9xFmiA5M4RVnXRpMcZ4n2
TOQkZcxHkU0eySb+pKnZSmrKu0mWH2JT7K9+AicorR9JVnkEG/mDJmYrqCHv
Ipv8IBtj/fXjOU4p/QiyyAfILaeyg+H6/GoaB3hd/zuN5eVUl3eSVW4X12P9
4xyqXdgbZ01/jJLxeWSW95NL7sh2no2zrPZgP6/pf6ORvIxqcmG1N4fjedNn
UdvGa2Nd4tyrndnDOP1RSsRnE/8fi6h9Oco7+pxqB7bxTPyOqN3jGq/qf6Wh
vJSqciG1F4fiOdRnVtvEa2Nd4zdH7cRuxuoHqic5IheP7+A/cJXq8A==
        "]]]}, {}, 
     {Hue[0.9060679774997897, 0.6, 0.6], Opacity[0.2], EdgeForm[None], 
      GraphicsGroupBox[PolygonBox[CompressedData["
1:eJwl1XcYTnUYxvHXyMgohDTsTfYmo6zKnlFSZtkjqzIqu8gmq+wt2YQi2kRL
0yjKzqzI6PNc/fG97vt+nvOe3znnN95c7Xo26ZE0kUgkwT5mbrJEYkjKRCIr
vyd5InFOnkWr063ozH+kl42fjOpyX3k5bmCAWj61KvwzmIHT6KieST0LXxlP
YzpOoYNeRr3MfCW0xTScRHu9DHp38RXxFKbiBNrp3amXia+ANpiCP2JsvTv0
MvLl8SQm4/cYWy+9Xga+HJ7AJByPsfXS6d3Jl0VrTMSxGFsvrd4dfBm0wgT8
FmPrpdFLz5fG43gDv8bYerfrpeNLoSXG42iMrZdaLy1fEi0wDkdibL1Uemn4
EmiO13E4xtZLqXc7XxzN8BoOxdh6KfRS88XQFGPxS4ytd5teKv4BNMEY/Bxj
6yXXS8mnwG1IjmRIiiSxUHDLYrmJGygqN8Zo/BTP6B7J3OO6XhG5EUbhx3hG
vaR6/+rtke+WJ6GaWh95Ga6jv1petcL8ZqSRR6C0WkM5Dz8Hj8oj5R/iHeUk
8jX3PsvP5KvRLejE73bNd/yrfFa6jE6kVWlvvZ30V/kNWoyuoUtp81D99+gn
cr94fnk+7SfnoYXkD+kf8hRajq6na2gbukn/S/6lmC86HKX4BvHd+TF8bjob
j/Aj4nn4Hvz3MUd8gr/q3arym9FR/lAvCz8BD8q9Yk75JWgmL5Gv4Xk5t1yQ
34jU8R1QUq2+PBwHYx7VbuEf4/SUF+Mq+qrlcm0BfgNSya+ghFo9+dX4tjHX
ajfxt9/HobII/6CPWk7X5ucfwyv4Fg3Vb+Av11/BZeRTfxQv4xs00L+OS3rd
5YX4G73VcrhnXv4RDMPXqK/+Ly66vpu8AH+hl1p21+fh1yOl/DKKq9WVh+Ir
1FO7hgt+v0vOHGsCVVzXNeYdV9BT7f6YN35d7Bd5GIqp1ZGH4EC8r9pVnHe/
nfJd/HhUdl0XuSi/GE3lefJl9JDvk3Pxa2MfykPxgFptOVecyagrD5b3xzeL
ecOfxvlAzsSPQyXXPCcX4Rehify2fAnd5XvlnHxZ/h08Kb8b+z7+B1BUriXn
jD2FOvJLsZ7ju8dc45wxH6Sb0EH/fb2M/OuoKD8rF+YXorH8lvwx/zx/ke/G
38Pn4Mvwq/FE7B95H/8in4wORhG+pnoO/k3Ull+UP+C7J///P6xurCmc9VxV
6Ea019sR6y7Wbpz99DVU4DurF+IXoJE8V/6I78tf4Lvy2fjsfGl+FVrL78h7
+Rf4pLG/UZh/OM5CfnT8hs5ALf4F9ff5bvxevg5/BWc855l4H/XKdAPa8dtj
D8Q6jf8jOhbl+U7qR2MdxZ6m89GQn6O+h+/Dn+e78Hfz9/O/85P5UnQlWvGr
1b/gB/FJ4jujEP9QnNf8qPgtnY6a/CD1HXxX/gu+Nn8Zpz3/6XhP9UpxPtH1
9Bm6LfZl7I3436RL6RhajnbUOxLrNM6WWH+xB2gDOltvN9+b/5OfF+tYzkrv
k4/zk/iSdB1dQR+nq/Q+5wfyiVjz8d1pQVoj/iv4kXGP+A50Gn2YDtTbznfh
P+fnxrqPcwenvN+p+A5qFWOd03X0afpenBuxP+O/ny6ho2lZ2kHvcOyDOPti
Xcfeo/XprPjP4Hvx5/i3Y5/IWei98jF+Il+CrqXLaUu6Uu8zfgB/K87DmBe5
AK0uf8+PiHvQFXQqfYgO0NvGP8d/xs+JfSRfxEnvd5JOU6sQ+4WupW3p1phz
eiDOA5qOLqajaBnaPvYePRT7ieaL/RF7nNajM/W30l1yT3pWfiv2nJyZ3iPv
or/JE2hx+i5dRlvEvMZz00/l/vRmnOkxX3J+Wi32FD0oD4/70eV0Cq1B++tv
iXmSn437yLNjj8oXcMK775ZP8FNp+dh/cQbSp+iWWBd0f5w/NG2sn9if6r/E
nlTLS/8DJPdlUg==
        "]]]}, {}, 
     {Hue[0.1421359549995791, 0.6, 0.6], Opacity[0.2], EdgeForm[None], 
      GraphicsGroupBox[PolygonBox[CompressedData["
1:eJwV1mW4VUUYhuFNdzdKd6co0g2ClKJ0pwHSaYAN2Cgm0mAgFq1IKY3SIBIG
XQooDd7fj+d6n3dmn7X2WTOzzinUc1DbgUkTiUQSTCNDUyQST6ZKJC4nTyTG
yU9TJhKtZTI5Evn4az5zAK30/9CAD8FKVNb3IzuvhO74HAWNrY/Pu242vSK6
4TMUMP4T/jWXVa+ArvgU+Y3/iEvmsujl0QWfIJ/xdbhoLrNeDp0xH3caX4sL
5jLpZdEJ83CH8TX4x1xGvQw6Yi7yGl+Nv82dxzmcxRmcximcxAkcRwY/Uxod
MAd5/OwqHDOXXi+F9piN3MZ/wFFz9fXB+D6ek7F9SMfHYyvq6SdQkh+L78eT
ePYP81nIpa/EX66VVI7AneZfNfcrWsbzRD3+sWxk7h/eJ+7Dn+Av8LL8O/6w
rKjvRVp9tD6b3yev6o/Ix/Vs8pn47vIVvYrcEs9W1tWPo4Q+XH+P15FH9V6y
g56QD+lP8aJ8Js/Jv8effpckcjjuiOubm8Lv5fv5/bEPUJf/jd7xXc0N4iti
3+h7kIY/jc2oE2uB4vyvWAt+G+34DOTg3+EP956s70OL2FPx3flALI99p+9G
6vju2ITasZYoxh/EdGTXV+B316utP45lsTeN7UIqXhQPxLogm7HlOOLzKfUi
aItpyGp8GQ6bO4QUxgqjDT5CFnNLcdBcLf0xLI29bmwnkvNCaI0PkdnYEvzm
8zX1R7Ek9r+xHUgWZx8bUSv2FgrGOccHyKQvxgE/P0nfi+ZxxlAj9ggWx3nQ
tyMpH4cNqBnriwKxN/E+MuqL8KvrTdT34L44l7Hm/Hzsm1hPazyAL4rzpP8S
Z4GPxXrUiPVDfv5n7GV+C/fz95CBfxvvJfd5Wd+NZnHGUZ2fQ89YW/fpz79F
Sf3n2K/8SjxbntX8GP4T7o01jvch/wMP8Ztowd9Fev5NnGv3TMhhyOvnXzK3
C03187iHn0WP2Bvm+/HneRn+DS/Bt8WedZ3LsWY8i7nRfDKvzH/k1WMPxTuA
/452/Aaax5rKIj43lafjX8c5d73b+lCex9yL/K14Hnwnb8LP4W5+Bt15SnN9
+XO8NP+aF+db43m73n+xB3hmc6P4JF6Jr+P3xD6Oc82PxHnh1+P9EntEFva5
d3ha/lWcY9f7RLYyfsv4EJ6bv8DfjOfGd/DG/CyqxZmRDY2f5t14Ct6HP8tL
8a94Mb4l1sr1Z8lmxv81PoBn4iP5RF6Rr+V380OxdrGusrbxw3F++bX4+diH
spDxt3ka/mW8K1x/vmxp/KbxwTwXf56/Ec+Vb4/vKRvpZ3BXnGvZwNgp3ld2
jXMse+sTeEn+Zew3WVTfHOvsXjNlU2OX4neJfaxnlCP0l3kFvoZ3lNXinRHr
rk+VtYwdijMg2+pX41r6mDj/xqbE7ytT6wvjPeZ+8+J8GbsR77j4e6LnlM/p
r8d68F94V9lQP42q8R6S9Y2d5H1kl3jvyF76eF6CL4z9K4vom2KfuN8M2cTY
RXP945zoGeRw/SVenq/mHeRd8Y6L/aK/I2saOxhnTLbRr8S19NHxPjL2Fm8r
U+lfYKf7jdXnxnmW1+P8x98ZPYd8Ns5N/B8UayZ/1rvIBvopVNFH6h/wevKE
3lt21pPKnvqg+DuqF5dfxHmQhfWNsa/cf5Q+nTeWF8z3i7Onp5fD9CfizOrl
5Cq9vayqH4h9pg+L/chryN/i/MrW+uW4pj4wzijPL9/U28iU+gLscP8x+px4
f8hr8d6RA/XsckKcx/hfI9ZUbtM7y/r6yXgn6SP093ldeVzvxHvIp2UxYwt4
Ib4h9pv7/Q+9T1LV
        "]]]}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}}, {{}, {}, 
     {Hue[0.67, 0.6, 0.6], LineBox[CompressedData["
1:eJwl1WWYlmUQBtBdupTuXLq7Q7p7aZValIalu1FpFCxUsIMuO+juBruxuxWM
M5c/zjf3zPvl7PNem5SSmjw2MSEh4aqHqPM9lOasfEmdxgr5oDqM3Nysf0Ht
Q1r26k+r4ylKLf16tSO/x3M5Jo+mAPP1u9RBZOOY/pw6iRKk0S9Qy3BOXskh
eTh5uEX/otqXdOzTn1EnUIza+g1qJ/6I53JcHkNBFuh3q4O5geP6tCyUy3Je
vpvD8gjycqv+JbUf6dmvr8NGuTN/xnVOyLHQQizU71FTuJET+nTcIZfjgnwP
/Xk59koGDujrsknuwl9xPV5Heu40K89FeRUDeCX2QkYO6uuxWe7KtbgeryMD
d5lV4JK8moHUJyOLzCtyWb6XQTQgE5lZ7Folrsj3MZiGbDHrxnX51fgMsrDE
rDJvyveTQiO2mnXnb/m1+FyystSsCm/JDzAk3i/2TyYO6RuzTU7mH/n1+F7s
1Q8hOyf12VgmV+Vt+UGOyCPJx23x2Wp/MnNY34Ttcg/+ld/gpJxKYZbo98Vr
yRHfk1mcMj+vTiaJd5kb58t8uVqN93lHf1mdzhr5qDqKD8kf35PZfMLt8dvU
AXxAltgjM/mYI66fVSfyEcXj/ZnDp9zk+g61J3FzX2EGu7Sn1HEUYal+f3we
OTmtv6BOoWScXf0KtXr8LvkhhsZu9APJylF9U3bKvUhkd+yf7HEP62vwnvww
w2hGjrjXzGvGfuRHGE5zcpKL3OQhL/nITwEKUijuIa+tFTuS1zKCFhSO+8O8
duxXXsdIWlIkzr55ndid/CijaEXROPvmdWPP8mOMpjXF4tyb14u/kfw4Y2hD
8Tjj5vVj//ITjKUtJeI8mzfgqvwkqbQjKc6meUM+k59iHO0pyRrzRnwuP814
OlAq/hbmjflCfoYJdKR07Nm8CV/KzzKRTpSJPcf54Cv5OSbRmbKxQ/OmfC2v
ZzJdKBc7NG/GN/IGptCV8rFD8+Z8K29kKt2oEDs0b8F38iam0Z2KsUPzlnwv
b2Y6yVSKHZq34gd5CzPoQeXYoXlrfpS3MpOeVIkdmrfhJ3kbs+hF1diheVt+
lrczm95Uix2at+MXeQdz6EP12KF5e36VdzKXvtSIHZp34Df5eebRL7JZb9Kw
R7+cA/JQcnFGf1GdSqm4P5iX+P//45qu/Qdh8enf
       "]]}, 
     {Hue[0.9060679774997897, 0.6, 0.6], LineBox[CompressedData["
1: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
jTZupw==
       "]]}, 
     {Hue[0.1421359549995791, 0.6, 0.6], LineBox[CompressedData["
1:eJwV1nf8jlUcxvGHjOyZmVl2dihJRkYZycjee6+okFK0KLRsFdnKKHu0jFI2
lVEUskeREan394/P6/pc5zzPfXvu+5zzU6BT/8b9kiQSiVVJE4ktyRKJRSkS
iWSYkDyReBR34brxrfgW32EbvscP2I4d2Ild2I3Fvp8cE323FrLhoF4eX/DB
uBHX0wvgE71QykTiBd6Rt5YnZTVjU/lQWU4/zWugjb5Dv1++pQ+SL+lZZT+9
t/xHryfn6MPkHvf7hKfAk/rb5vPKZ/V+srZ+jTdCB/2w/pB8T39aZtcP8fvR
Qv9SLylf1QfIp/W0spveXf6l15Yf6s/GvyeeHS+Ipvqn5gvLF/X+spOeVLbR
u8hTenU5TX9GltfP8Jpoq+/UK8jx+mD5crwr2V/vI2/q9eVcfbjc6/6f8pRo
rL9jPp98Tq8T7zieSzx/Y7/oVeT7eg5+WFZAS2Nf6aXka/oQno535z3kZb2O
/Ei/GetE3oNmxpaYKyJH6Z35Hbwt7ypP6zXk9Hi+/Kx8FO2M7dIrygn66FhL
fADvK2/pDeQ8fZ/7LZF3oomxd83ll8P0urHe4nejk7Ff9YflJD0n/0VWRCtj
X+ul5eux7nh63oP3lFf0unKWfiv2gLwXTxlbaq5orMN4fzwZb8e7yTN6TTkj
niM/J2uhvbHdeiU5UR/Ds/OB/F/ekM/n+91rqUyF94wXMD6cP8b/id+LI7yq
8ck8F/9VVsI3vIzxN2Id8Qy8J/+bP8Znx71iL8tCWGa8WKyneDc8OW/Pz8Z5
wGfGs+LnZW3s4Q/EfuKv8Bx8EL/Nn+AL+I+uv0ymxvvGCxofwR/nN2M/4CjP
jSP8AWziZX1ubOwfnpH34lf57Th3eGEs14ubGx3PmqfgHfi5eK64EOsbe/mD
se75qzwnH8z/4z+53nKeBpP0e8w9z+vxW7F+8Ru/G0f5g9jMy/ncOP4cz8R7
82v8vzgTeRF8ppcwNybOBZ6Sd+Tn47nhYqzPWL/8NeSKs0RP4GfX+UymxeTY
z/g31ht+53nwG6+MLXwYMvt+H/06T2AnL4rPeQ/cGWeNfiGeBy7FOoo1xl/H
Aff8XE+HKbG/4nnz5jgWZyZ+5w9hKx+OJNilF8MK3hOp3KezfpFXxp/xvmMt
8Dfi74H7rNDTY2qs9TiPcEyvgm/5iDgTsVsvjpW8V5zL+CveD37iY+Nsdr2V
egZMi7UX+x/H9YfxHX8+zh3s0UtgFe8dZ12ccb6/ylhGTNcbxT6LfYy9xu7D
at4nzo44M3x+tbFMmKE/Ges69kvsPXNHsMZcZsw01jjWVazPWEPm1hrPgg/0
Jrg31gb2GSuJNbxv7Ol4xz6/zlhWfKg3RSGc0KtiGx8Z7xb79VJYy/vhEVzW
68d64uPi/bneev0ufKQ3izXLW+A4L4w/+CP4nr8Q7xM/6qWxjvdHau+4i36J
V8MV3gAH4p3HGczfjH3Nh/AksYbce4PMhlnxu82NjDUd65W35J3lifi3yyn6
EFlEP8mrobX+g15evqkPjL+jehbZV+8lb+iPy49jf8rUsc95mVjL+nr9PvmK
PoCn4V35n7wW/4BX53/LhjjI34ozwNxQPWk8K79lo8yO2eaax14w30r/gxfF
qbgOtvNRcR/8rJfFBj4QNeJdutYXxnLgY70FiiFtvAtzXxrPiTl6SxRHungm
5k7hNM7gLM7hPC7gIi7hK9/Nhbm+0wolkD72pbmvjefGPL11PBdkiD1m7hvj
d2O+3gYlkTHWlLlNxvNggd4WpZAp1oG5zcbzYqHeDqWROZ6nuS3G82GR3h5l
4t3havw/03h+LNY7oCyy4oCxctjIB6FmfF5/Aof4eOTx7J/R70AjvlCOkNdc
939ShmJm
       "]]}}}],
  AspectRatio->NCache[GoldenRatio^(-1), 0.6180339887498948],
  Axes->True,
  AxesLabel->{None, None},
  AxesOrigin->{0, 0},
  Method->{"AxesInFront" -> True},
  PlotRange->{{-8, 12}, {0., 0.18393969945312313`}},
  PlotRangeClipping->True,
  PlotRangePadding->{
    Scaled[0.02], 
    Scaled[0.02]}]], "Output",
 CellChangeTimes->{3.6094011908269997`*^9}]
}, Open  ]],

Cell[CellGroupData[{

Cell[BoxData[
 RowBox[{"Mean", "[", 
  RowBox[{"ExtremeValueDistribution", "[", 
   RowBox[{"\[Alpha]", ",", "\[Beta]"}], "]"}], "]"}]], "Input",
 CellID->1988],

Cell[BoxData[
 RowBox[{"\[Alpha]", "+", 
  RowBox[{"EulerGamma", " ", "\[Beta]"}]}]], "Output",
 CellChangeTimes->{3.609401222837*^9},
 ImageSize->{104, 15},
 ImageMargins->{{0, 0}, {0, 0}},
 ImageRegion->{{0, 1}, {0, 1}}]
}, Open  ]],

Cell[CellGroupData[{

Cell[BoxData[
 RowBox[{"Variance", "[", 
  RowBox[{"ExtremeValueDistribution", "[", 
   RowBox[{"\[Alpha]", ",", "\[Beta]"}], "]"}], "]"}]], "Input",
 CellID->16798],

Cell[BoxData[
 FractionBox[
  RowBox[{
   SuperscriptBox["\[Pi]", "2"], " ", 
   SuperscriptBox["\[Beta]", "2"]}], "6"]], "Output",
 CellChangeTimes->{3.609401228651*^9},
 ImageSize->{38, 35},
 ImageMargins->{{0, 0}, {0, 0}},
 ImageRegion->{{0, 1}, {0, 1}}]
}, Open  ]],

Cell["\<\
In order to set the parameters of the EVD, we need to arrange them so that \
the mean and variance match those of the equivalent Gaussian distribution \
with mean \[Mu] = 0 and standard deviation \[Sigma].  hence:\
\>", "Text",
 CellChangeTimes->{{3.6094012401*^9, 3.609401366602*^9}}],

Cell[BoxData[
 RowBox[{"\[Beta]", "=", 
  RowBox[{
   RowBox[{
    FractionBox[
     RowBox[{"\[Sigma]", 
      SqrtBox["6"]}], "\[Pi]"], "  ", "and", " ", "\[Alpha]"}], "=", 
   RowBox[{
    RowBox[{"-", "EulerGamma"}], " ", "\[Beta]"}]}]}]], "Text",
 CellChangeTimes->{{3.609401359582*^9, 3.60940141055*^9}, {3.609401442076*^9, 
  3.609401483225*^9}}],

Cell["\<\
The code for a  version of the model using the GED is given as follows\
\>", "Text",
 CellChangeTimes->{{3.609401495054*^9, 3.6094015377130003`*^9}}],

Cell[BoxData[
 RowBox[{
  RowBox[{"WinRateExtreme", "[", 
   RowBox[{
   "currentPrice_", ",", "annualVolatility_", ",", "BarSizeMins_", ",", " ", 
    "nTicksPT_", ",", " ", "nTicksSL_", ",", "minMove_", ",", " ", 
    "tickValue_", ",", " ", "costContract_"}], "]"}], ":=", 
  RowBox[{"Module", "[", 
   RowBox[{
    RowBox[{"{", " ", 
     RowBox[{
     "nMinsPerDay", ",", " ", "periodVolatility", ",", " ", "alpha", ",", " ",
       "beta", ",", "tgtReturn", ",", " ", "slReturn", ",", "tgtDollar", ",", 
      " ", "slDollar", ",", " ", "probWin", ",", " ", "probLoss", ",", " ", 
      "winRate", ",", " ", "expWinDollar", ",", " ", "expLossDollar", ",", 
      " ", "expProfit"}], "}"}], ",", " ", "\n", 
    RowBox[{
     RowBox[{"nMinsPerDay", " ", "=", " ", 
      RowBox[{"250", "*", "6.5", "*", "60"}]}], ";", "\n", 
     RowBox[{"periodVolatility", " ", "=", " ", 
      RowBox[{"annualVolatility", " ", "/", " ", 
       RowBox[{"Sqrt", "[", 
        RowBox[{"nMinsPerDay", "/", "BarSizeMins"}], "]"}]}]}], ";", 
     "\[IndentingNewLine]", 
     RowBox[{"beta", " ", "=", " ", 
      RowBox[{
       RowBox[{"Sqrt", "[", "6", "]"}], "*", 
       RowBox[{"periodVolatility", " ", "/", " ", "Pi"}]}]}], ";", 
     "\[IndentingNewLine]", 
     RowBox[{"alpha", "=", 
      RowBox[{
       RowBox[{"-", "EulerGamma"}], "*", "beta"}]}], ";", "\n", 
     RowBox[{"tgtReturn", "=", 
      RowBox[{"nTicksPT", "*", 
       RowBox[{"minMove", "/", "currentPrice"}]}]}], ";", 
     RowBox[{"tgtDollar", " ", "=", " ", 
      RowBox[{"nTicksPT", " ", "*", " ", "tickValue"}]}], ";", 
     "\[IndentingNewLine]", 
     RowBox[{"slReturn", " ", "=", " ", 
      RowBox[{"nTicksSL", "*", 
       RowBox[{"minMove", "/", "currentPrice"}]}]}], ";", 
     "\[IndentingNewLine]", 
     RowBox[{"slDollar", "=", 
      RowBox[{"nTicksSL", "*", "tickValue"}]}], ";", "\[IndentingNewLine]", 
     RowBox[{"probWin", "=", 
      RowBox[{"1", "-", 
       RowBox[{"CDF", "[", 
        RowBox[{
         RowBox[{"ExtremeValueDistribution", "[", 
          RowBox[{"alpha", ",", " ", "beta"}], "]"}], ",", "tgtReturn"}], 
        "]"}]}]}], ";", "\[IndentingNewLine]", 
     RowBox[{"probLoss", "=", 
      RowBox[{"CDF", "[", 
       RowBox[{
        RowBox[{"ExtremeValueDistribution", "[", 
         RowBox[{"alpha", ",", " ", "beta"}], "]"}], ",", "slReturn"}], 
       "]"}]}], ";", "\[IndentingNewLine]", 
     RowBox[{"winRate", "=", 
      RowBox[{"probWin", "/", 
       RowBox[{"(", 
        RowBox[{"probWin", "+", "probLoss"}], ")"}]}]}], ";", 
     "\[IndentingNewLine]", 
     RowBox[{"expWinDollar", "=", 
      RowBox[{"tgtDollar", "*", "probWin"}]}], ";", "\[IndentingNewLine]", 
     RowBox[{"expLossDollar", "=", 
      RowBox[{"slDollar", "*", "probLoss"}]}], ";", "\[IndentingNewLine]", 
     RowBox[{"expProfit", "=", 
      RowBox[{"expWinDollar", "+", "expLossDollar", "-", "costContract"}]}], 
     ";", "\[IndentingNewLine]", 
     RowBox[{"{", 
      RowBox[{"expProfit", ",", " ", "winRate"}], "}"}]}]}], "]"}]}]], "Input",
 CellChangeTimes->{{3.6093009104230003`*^9, 3.609300963664*^9}, {
  3.609301035613*^9, 3.6093010759370003`*^9}, {3.609301118639*^9, 
  3.609301144227*^9}, {3.609301263416*^9, 3.609301266804*^9}}],

Cell[CellGroupData[{

Cell[BoxData[
 RowBox[{
  RowBox[{"WinRateExtreme", "[", 
   RowBox[{
   "1900", ",", "0.05", ",", "15", ",", "2", ",", "30", ",", "0.25", ",", 
    "12.50", ",", "3"}], "]"}], "[", 
  RowBox[{"[", "2", "]"}], "]"}]], "Input",
 CellChangeTimes->{{3.609301210969*^9, 3.609301212697*^9}}],

Cell[BoxData["0.21759015979697247`"], "Output",
 CellChangeTimes->{3.609301213435*^9, 3.609301272008*^9}]
}, Open  ]],

Cell["\<\
We can now produce the same plots for the EVD version of the model that we \
plotted for the Gaussian versions :\
\>", "Text",
 CellChangeTimes->{{3.6094016321549997`*^9, 3.609401636483*^9}, {
  3.6094017203450003`*^9, 3.609401759396*^9}}],

Cell[CellGroupData[{

Cell[BoxData[
 RowBox[{"Manipulate", "[", 
  RowBox[{
   RowBox[{"Plot3D", "[", 
    RowBox[{
     RowBox[{
      RowBox[{"WinRateExtreme", "[", 
       RowBox[{
       "1900", ",", "Volatility", ",", "BarSizeMins", ",", "nTicksPT", ",", 
        "nTicksSL", ",", "0.25", ",", "12.50", ",", "3"}], "]"}], "[", 
      RowBox[{"[", "1", "]"}], "]"}], ",", 
     RowBox[{"{", 
      RowBox[{"nTicksPT", ",", "1", ",", "30"}], "}"}], ",", 
     RowBox[{"{", 
      RowBox[{"nTicksSL", ",", 
       RowBox[{"-", "1"}], ",", 
       RowBox[{"-", "30"}]}], "}"}], ",", 
     RowBox[{"PlotLabel", "\[Rule]", 
      RowBox[{"Style", "[", 
       RowBox[{"\"\<Expected Profit by Bar Size and Volatility\>\"", ",", " ", 
        RowBox[{"FontSize", "\[Rule]", "18"}]}], "]"}]}], " ", ",", 
     RowBox[{"AxesLabel", "->", 
      RowBox[{"{", 
       RowBox[{
       "\"\<Profit Target (ticks)\>\"", ",", " ", "\"\<Stop Loss (ticks)\>\"",
         ",", " ", "\"\<Exp. Profit $\>\""}], "}"}]}], ",", " ", 
     RowBox[{"ImageSize", "\[Rule]", "Large"}]}], "]"}], ",", 
   RowBox[{"{", 
    RowBox[{"BarSizeMins", ",", 
     RowBox[{"{", 
      RowBox[{"1", ",", "3", ",", "5", ",", "10", ",", "15", ",", "30"}], 
      "}"}]}], "}"}], ",", 
   RowBox[{"{", 
    RowBox[{"Volatility", ",", "0.05", ",", "0.5"}], "}"}], ",", 
   RowBox[{"Initialization", "\[Rule]", 
    RowBox[{"(", 
     RowBox[{
      RowBox[{"BarSizeMins", ":=", "3"}], ";", " ", 
      RowBox[{"Volatility", ":=", "0.1"}]}], ")"}]}], ",", 
   RowBox[{"SaveDefinitions", "->", "True"}]}], "]"}]], "Input",
 CellChangeTimes->{{3.609216468752*^9, 3.609216470182*^9}, {3.609217520447*^9,
    3.609217604943*^9}, {3.609217655238*^9, 3.609217655771*^9}, {
   3.609217719065*^9, 3.609217743307*^9}, {3.609217829574*^9, 
   3.609217830421*^9}, {3.6092178852609997`*^9, 3.609217916406*^9}, {
   3.60921801577*^9, 3.6092180599440002`*^9}, {3.6092180905769997`*^9, 
   3.60921809112*^9}, {3.6092182261359997`*^9, 3.6092183135360003`*^9}, {
   3.609218347572*^9, 3.6092183760699997`*^9}, {3.609218445571*^9, 
   3.6092184625620003`*^9}, {3.609218621957*^9, 3.609218635164*^9}, {
   3.609218732116*^9, 3.6092187489370003`*^9}, {3.609218822211*^9, 
   3.609218877525*^9}, {3.609218921321*^9, 3.609218926271*^9}, {
   3.609218995487*^9, 3.609219036843*^9}, {3.609219201856*^9, 
   3.6092192106470003`*^9}, {3.609219251494*^9, 3.609219252303*^9}, {
   3.6092338791935997`*^9, 3.6092338794526*^9}, {3.609294868387*^9, 
   3.609294906047*^9}, {3.6092949443459997`*^9, 3.609294973723*^9}, 
   3.6092952112130003`*^9, {3.609295847914*^9, 3.609295867137*^9}, {
   3.609296395974*^9, 3.60929639991*^9}, {3.609296438006*^9, 
   3.609296438356*^9}, {3.6092964720889997`*^9, 3.609296475638*^9}, {
   3.609296732664*^9, 3.609296761591*^9}, {3.609399547244*^9, 
   3.609399587701*^9}, {3.609399748417*^9, 3.609399750558*^9}, {
   3.609399826719*^9, 3.60939985451*^9}, {3.609399894207*^9, 
   3.6093999315959997`*^9}, 3.609400000071*^9, {3.609400216126*^9, 
   3.609400267564*^9}, {3.609400354822*^9, 3.6094003848459997`*^9}, {
   3.609400564498*^9, 3.60940056676*^9}, {3.609401701644*^9, 
   3.609401702924*^9}}],

Cell[BoxData[
 TagBox[
  StyleBox[
   DynamicModuleBox[{$CellContext`BarSizeMins$$ = 
    3, $CellContext`Volatility$$ = 0.1, Typeset`show$$ = True, 
    Typeset`bookmarkList$$ = {}, Typeset`bookmarkMode$$ = "Menu", 
    Typeset`animator$$, Typeset`animvar$$ = 1, Typeset`name$$ = 
    "\"untitled\"", Typeset`specs$$ = {{
      Hold[$CellContext`BarSizeMins$$], {1, 3, 5, 10, 15, 30}}, {
      Hold[$CellContext`Volatility$$], 0.05, 0.5}}, Typeset`size$$ = {
    576., {211., 215.}}, Typeset`update$$ = 0, Typeset`initDone$$, 
    Typeset`skipInitDone$$ = False, $CellContext`BarSizeMins$720461$$ = 
    0, $CellContext`Volatility$720462$$ = 0}, 
    DynamicBox[Manipulate`ManipulateBoxes[
     1, StandardForm, 
      "Variables" :> {$CellContext`BarSizeMins$$ = 
        1, $CellContext`Volatility$$ = 0.05}, "ControllerVariables" :> {
        Hold[$CellContext`BarSizeMins$$, $CellContext`BarSizeMins$720461$$, 
         0], 
        Hold[$CellContext`Volatility$$, $CellContext`Volatility$720462$$, 0]},
       "OtherVariables" :> {
       Typeset`show$$, Typeset`bookmarkList$$, Typeset`bookmarkMode$$, 
        Typeset`animator$$, Typeset`animvar$$, Typeset`name$$, 
        Typeset`specs$$, Typeset`size$$, Typeset`update$$, Typeset`initDone$$,
         Typeset`skipInitDone$$}, "Body" :> Plot3D[
        Part[
         $CellContext`WinRateExtreme[
         1900, $CellContext`Volatility$$, $CellContext`BarSizeMins$$, \
$CellContext`nTicksPT, $CellContext`nTicksSL, 0.25, 12.5, 3], 
         1], {$CellContext`nTicksPT, 1, 30}, {$CellContext`nTicksSL, -1, -30},
         PlotLabel -> 
        Style["Expected Profit by Bar Size and Volatility", FontSize -> 18], 
        AxesLabel -> {
         "Profit Target (ticks)", "Stop Loss (ticks)", "Exp. Profit $"}, 
        ImageSize -> Large], 
      "Specifications" :> {{$CellContext`BarSizeMins$$, {1, 3, 5, 10, 15, 
         30}}, {$CellContext`Volatility$$, 0.05, 0.5}}, "Options" :> {}, 
      "DefaultOptions" :> {}],
     ImageSizeCache->{627., {272., 277.}},
     SingleEvaluation->True],
    Deinitialization:>None,
    DynamicModuleValues:>{},
    Initialization:>({{$CellContext`WinRateExtreme[
           Pattern[$CellContext`currentPrice, 
            Blank[]], 
           Pattern[$CellContext`annualVolatility, 
            Blank[]], 
           Pattern[$CellContext`BarSizeMins, 
            Blank[]], 
           Pattern[$CellContext`nTicksPT, 
            Blank[]], 
           Pattern[$CellContext`nTicksSL, 
            Blank[]], 
           Pattern[$CellContext`minMove, 
            Blank[]], 
           Pattern[$CellContext`tickValue, 
            Blank[]], 
           Pattern[$CellContext`costContract, 
            Blank[]]] := 
         Module[{$CellContext`nMinsPerDay, $CellContext`periodVolatility, \
$CellContext`alpha, $CellContext`beta, $CellContext`tgtReturn, \
$CellContext`slReturn, $CellContext`tgtDollar, $CellContext`slDollar, \
$CellContext`probWin, $CellContext`probLoss, $CellContext`winRate, \
$CellContext`expWinDollar, $CellContext`expLossDollar, \
$CellContext`expProfit}, $CellContext`nMinsPerDay = (250 6.5) 
             60; $CellContext`periodVolatility = \
$CellContext`annualVolatility/
             Sqrt[$CellContext`nMinsPerDay/$CellContext`BarSizeMins]; \
$CellContext`beta = 
            Sqrt[6] ($CellContext`periodVolatility/
              Pi); $CellContext`alpha = (-
              EulerGamma) $CellContext`beta; $CellContext`tgtReturn = \
$CellContext`nTicksPT ($CellContext`minMove/$CellContext`currentPrice); \
$CellContext`tgtDollar = $CellContext`nTicksPT $CellContext`tickValue; \
$CellContext`slReturn = $CellContext`nTicksSL \
($CellContext`minMove/$CellContext`currentPrice); $CellContext`slDollar = \
$CellContext`nTicksSL $CellContext`tickValue; $CellContext`probWin = 1 - CDF[
              
              ExtremeValueDistribution[$CellContext`alpha, \
$CellContext`beta], $CellContext`tgtReturn]; $CellContext`probLoss = CDF[
              
              ExtremeValueDistribution[$CellContext`alpha, \
$CellContext`beta], $CellContext`slReturn]; $CellContext`winRate = \
$CellContext`probWin/($CellContext`probWin + $CellContext`probLoss); \
$CellContext`expWinDollar = $CellContext`tgtDollar $CellContext`probWin; \
$CellContext`expLossDollar = $CellContext`slDollar $CellContext`probLoss; \
$CellContext`expProfit = $CellContext`expWinDollar + \
$CellContext`expLossDollar - $CellContext`costContract; \
{$CellContext`expProfit, $CellContext`winRate}], $CellContext`BarSizeMins$$ := 
         3, $CellContext`Volatility$$ := 0.1}; Null}; 
     Typeset`initDone$$ = True),
    SynchronousInitialization->True,
    UnsavedVariables:>{Typeset`initDone$$},
    UntrackedVariables:>{Typeset`size$$}], "Manipulate",
   Deployed->True,
   StripOnInput->False],
  Manipulate`InterpretManipulate[1]]], "Output",
 CellChangeTimes->{3.6094017042539997`*^9}]
}, Open  ]],

Cell[CellGroupData[{

Cell[BoxData[
 RowBox[{"Manipulate", "[", 
  RowBox[{
   RowBox[{"Plot3D", "[", 
    RowBox[{
     RowBox[{
      RowBox[{"WinRateExtreme", "[", 
       RowBox[{
       "1900", ",", "Volatility", ",", "BarSizeMins", ",", "nTicksPT", ",", 
        "nTicksSL", ",", "0.25", ",", "12.50", ",", "3"}], "]"}], "[", 
      RowBox[{"[", "2", "]"}], "]"}], ",", 
     RowBox[{"{", 
      RowBox[{"nTicksPT", ",", "1", ",", "30"}], "}"}], ",", 
     RowBox[{"{", 
      RowBox[{"nTicksSL", ",", 
       RowBox[{"-", "1"}], ",", 
       RowBox[{"-", "30"}]}], "}"}], ",", 
     RowBox[{"PlotLabel", "\[Rule]", 
      RowBox[{"Style", "[", 
       RowBox[{"\"\<Expected Win Rate by Volatility\>\"", ",", " ", 
        RowBox[{"FontSize", "\[Rule]", "18"}]}], "]"}]}], ",", 
     RowBox[{"AxesLabel", "->", 
      RowBox[{"{", 
       RowBox[{
       "\"\<Profit Target (ticks)\>\"", ",", " ", "\"\<Stop Loss (ticks)\>\"",
         ",", " ", "\"\<Exp. Win Rate (%)\n\>\""}], "}"}]}], ",", 
     RowBox[{"ImageSize", "\[Rule]", "Large"}]}], "]"}], ",", 
   RowBox[{"{", 
    RowBox[{"BarSizeMins", ",", 
     RowBox[{"{", 
      RowBox[{"1", ",", "3", ",", "5", ",", "10", ",", "15", ",", "30"}], 
      "}"}]}], "}"}], ",", 
   RowBox[{"{", 
    RowBox[{"Volatility", ",", "0.05", ",", "0.5"}], "}"}], ",", 
   RowBox[{"Initialization", "\[Rule]", 
    RowBox[{"(", 
     RowBox[{
      RowBox[{"BarSizeMins", ":=", "3"}], ";", " ", 
      RowBox[{"Volatility", ":=", "0.1"}]}], ")"}]}], ",", 
   RowBox[{"SaveDefinitions", "->", "True"}]}], "]"}]], "Input",
 CellChangeTimes->{{3.609218884693*^9, 3.6092188848269997`*^9}, {
   3.6092189172209997`*^9, 3.609218917336*^9}, {3.609219080127*^9, 
   3.609219129638*^9}, {3.609219262217*^9, 3.6092192738120003`*^9}, {
   3.6092338836436*^9, 3.6092338839396*^9}, 3.609296596507*^9, {
   3.609296629385*^9, 3.6092966314969997`*^9}, {3.609296783947*^9, 
   3.609296785284*^9}, {3.6094004278310003`*^9, 3.609400429623*^9}, {
   3.6094004696949997`*^9, 3.609400487844*^9}, {3.6094006592019997`*^9, 
   3.609400714017*^9}, {3.6094017748929996`*^9, 3.609401776337*^9}}],

Cell[BoxData[
 TagBox[
  StyleBox[
   DynamicModuleBox[{$CellContext`BarSizeMins$$ = 
    3, $CellContext`Volatility$$ = 0.1, Typeset`show$$ = True, 
    Typeset`bookmarkList$$ = {}, Typeset`bookmarkMode$$ = "Menu", 
    Typeset`animator$$, Typeset`animvar$$ = 1, Typeset`name$$ = 
    "\"untitled\"", Typeset`specs$$ = {{
      Hold[$CellContext`BarSizeMins$$], {1, 3, 5, 10, 15, 30}}, {
      Hold[$CellContext`Volatility$$], 0.05, 0.5}}, Typeset`size$$ = {
    576., {199., 204.}}, Typeset`update$$ = 0, Typeset`initDone$$, 
    Typeset`skipInitDone$$ = False, $CellContext`BarSizeMins$724405$$ = 
    0, $CellContext`Volatility$724406$$ = 0}, 
    DynamicBox[Manipulate`ManipulateBoxes[
     1, StandardForm, 
      "Variables" :> {$CellContext`BarSizeMins$$ = 
        1, $CellContext`Volatility$$ = 0.05}, "ControllerVariables" :> {
        Hold[$CellContext`BarSizeMins$$, $CellContext`BarSizeMins$724405$$, 
         0], 
        Hold[$CellContext`Volatility$$, $CellContext`Volatility$724406$$, 0]},
       "OtherVariables" :> {
       Typeset`show$$, Typeset`bookmarkList$$, Typeset`bookmarkMode$$, 
        Typeset`animator$$, Typeset`animvar$$, Typeset`name$$, 
        Typeset`specs$$, Typeset`size$$, Typeset`update$$, Typeset`initDone$$,
         Typeset`skipInitDone$$}, "Body" :> Plot3D[
        Part[
         $CellContext`WinRateExtreme[
         1900, $CellContext`Volatility$$, $CellContext`BarSizeMins$$, \
$CellContext`nTicksPT, $CellContext`nTicksSL, 0.25, 12.5, 3], 
         2], {$CellContext`nTicksPT, 1, 30}, {$CellContext`nTicksSL, -1, -30},
         PlotLabel -> 
        Style["Expected Win Rate by Volatility", FontSize -> 18], 
        AxesLabel -> {
         "Profit Target (ticks)", "Stop Loss (ticks)", "Exp. Win Rate (%)\n"},
         ImageSize -> Large], 
      "Specifications" :> {{$CellContext`BarSizeMins$$, {1, 3, 5, 10, 15, 
         30}}, {$CellContext`Volatility$$, 0.05, 0.5}}, "Options" :> {}, 
      "DefaultOptions" :> {}],
     ImageSizeCache->{627., {261., 266.}},
     SingleEvaluation->True],
    Deinitialization:>None,
    DynamicModuleValues:>{},
    Initialization:>({{$CellContext`WinRateExtreme[
           Pattern[$CellContext`currentPrice, 
            Blank[]], 
           Pattern[$CellContext`annualVolatility, 
            Blank[]], 
           Pattern[$CellContext`BarSizeMins, 
            Blank[]], 
           Pattern[$CellContext`nTicksPT, 
            Blank[]], 
           Pattern[$CellContext`nTicksSL, 
            Blank[]], 
           Pattern[$CellContext`minMove, 
            Blank[]], 
           Pattern[$CellContext`tickValue, 
            Blank[]], 
           Pattern[$CellContext`costContract, 
            Blank[]]] := 
         Module[{$CellContext`nMinsPerDay, $CellContext`periodVolatility, \
$CellContext`alpha, $CellContext`beta, $CellContext`tgtReturn, \
$CellContext`slReturn, $CellContext`tgtDollar, $CellContext`slDollar, \
$CellContext`probWin, $CellContext`probLoss, $CellContext`winRate, \
$CellContext`expWinDollar, $CellContext`expLossDollar, \
$CellContext`expProfit}, $CellContext`nMinsPerDay = (250 6.5) 
             60; $CellContext`periodVolatility = \
$CellContext`annualVolatility/
             Sqrt[$CellContext`nMinsPerDay/$CellContext`BarSizeMins]; \
$CellContext`beta = 
            Sqrt[6] ($CellContext`periodVolatility/
              Pi); $CellContext`alpha = (-
              EulerGamma) $CellContext`beta; $CellContext`tgtReturn = \
$CellContext`nTicksPT ($CellContext`minMove/$CellContext`currentPrice); \
$CellContext`tgtDollar = $CellContext`nTicksPT $CellContext`tickValue; \
$CellContext`slReturn = $CellContext`nTicksSL \
($CellContext`minMove/$CellContext`currentPrice); $CellContext`slDollar = \
$CellContext`nTicksSL $CellContext`tickValue; $CellContext`probWin = 1 - CDF[
              
              ExtremeValueDistribution[$CellContext`alpha, \
$CellContext`beta], $CellContext`tgtReturn]; $CellContext`probLoss = CDF[
              
              ExtremeValueDistribution[$CellContext`alpha, \
$CellContext`beta], $CellContext`slReturn]; $CellContext`winRate = \
$CellContext`probWin/($CellContext`probWin + $CellContext`probLoss); \
$CellContext`expWinDollar = $CellContext`tgtDollar $CellContext`probWin; \
$CellContext`expLossDollar = $CellContext`slDollar $CellContext`probLoss; \
$CellContext`expProfit = $CellContext`expWinDollar + \
$CellContext`expLossDollar - $CellContext`costContract; \
{$CellContext`expProfit, $CellContext`winRate}], $CellContext`BarSizeMins$$ := 
         3, $CellContext`Volatility$$ := 0.1}; Null}; 
     Typeset`initDone$$ = True),
    SynchronousInitialization->True,
    UnsavedVariables:>{Typeset`initDone$$},
    UntrackedVariables:>{Typeset`size$$}], "Manipulate",
   Deployed->True,
   StripOnInput->False],
  Manipulate`InterpretManipulate[1]]], "Output",
 CellChangeTimes->{3.6094017770629997`*^9}]
}, Open  ]],

Cell["\<\
Next we compare the Gaussian and EVD versions of the model, to gain an \
understanding of how the differing assumptions impact the expected Win Rate.\
\>", "Text",
 CellChangeTimes->{{3.609401815742*^9, 3.6094018655*^9}}],

Cell[CellGroupData[{

Cell[BoxData[
 RowBox[{"Manipulate", "[", 
  RowBox[{
   RowBox[{"ListPlot", "[", 
    RowBox[{
     RowBox[{"{", 
      RowBox[{
       RowBox[{"Table", "[", 
        RowBox[{
         RowBox[{
          RowBox[{"WinRate", "[", 
           RowBox[{"1900", ",", 
            RowBox[{"Volatility", "/", "100"}], ",", "BarSizeMins", ",", 
            "nTicksPT", ",", "nTicksSL", ",", "0.25", ",", "12.50", ",", 
            "3"}], "]"}], "[", 
          RowBox[{"[", "2", "]"}], "]"}], ",", 
         RowBox[{"{", 
          RowBox[{"Volatility", ",", "100"}], "}"}]}], "]"}], ",", 
       RowBox[{"Table", "[", 
        RowBox[{
         RowBox[{
          RowBox[{"WinRateExtreme", "[", 
           RowBox[{"1900", ",", 
            RowBox[{"Volatility", "/", "100"}], ",", "BarSizeMins", ",", 
            "nTicksPT", ",", "nTicksSL", ",", "0.25", ",", "12.50", ",", 
            "3"}], "]"}], "[", 
          RowBox[{"[", "2", "]"}], "]"}], ",", 
         RowBox[{"{", 
          RowBox[{"Volatility", ",", "100"}], "}"}]}], "]"}]}], "}"}], ",", 
     " ", 
     RowBox[{"Joined", "\[Rule]", "True"}], ",", 
     RowBox[{"PlotLegends", "\[Rule]", 
      RowBox[{"{", 
       RowBox[{"\"\<Gaussian\>\"", ",", "\"\<Extreme Value\>\""}], "}"}]}], 
     ",", 
     RowBox[{"AxesLabel", "\[Rule]", 
      RowBox[{"{", 
       RowBox[{"\"\<Volatility %\>\"", ",", "\"\<Exp. Win Rate (%)\>\""}], 
       "}"}]}], ",", 
     RowBox[{"PlotLabel", "\[Rule]", 
      RowBox[{"Style", "[", 
       RowBox[{
       "\"\<Expected Win Rate by Volatility - Gaussian vs Extreme Value\>\"", 
        ",", " ", 
        RowBox[{"FontSize", "\[Rule]", "18"}]}], "]"}]}], ",", " ", 
     RowBox[{"ImageSize", "\[Rule]", "Large"}]}], "]"}], ",", 
   RowBox[{"{", 
    RowBox[{"BarSizeMins", ",", 
     RowBox[{"{", 
      RowBox[{"1", ",", "3", ",", "5", ",", "10", ",", "15", ",", "30"}], 
      "}"}]}], "}"}], ",", 
   RowBox[{"{", 
    RowBox[{"nTicksPT", ",", "1", ",", "30"}], "}"}], ",", 
   RowBox[{"{", 
    RowBox[{"nTicksSL", ",", 
     RowBox[{"-", "2"}], ",", 
     RowBox[{"-", "30"}]}], "}"}], ",", 
   RowBox[{"Initialization", "\[Rule]", 
    RowBox[{"(", 
     RowBox[{
      RowBox[{"BarSizeMins", ":=", "3"}], ";", " ", 
      RowBox[{"Volatility", ":=", "0.1"}], ";", 
      RowBox[{"nTicksPT", ":=", "2"}], ";", 
      RowBox[{"nTicksSL", ":=", 
       RowBox[{"-", "6"}]}]}], ")"}]}], ",", 
   RowBox[{"SaveDefinitions", "->", "True"}]}], "]"}]], "Input",
 CellChangeTimes->{{3.609301163696*^9, 3.609301165*^9}, {
   3.6093015180629997`*^9, 3.6093015446800003`*^9}, {3.609301575988*^9, 
   3.6093015796280003`*^9}, {3.609301838216*^9, 3.609301871337*^9}, {
   3.609302011455*^9, 3.609302066384*^9}, 3.609302260212*^9, {
   3.609302325124*^9, 3.609302335137*^9}, {3.60930599145*^9, 
   3.6093059947539997`*^9}, 3.609401881591*^9, {3.609401912156*^9, 
   3.609402079676*^9}, {3.609404668894*^9, 3.609404669777*^9}, {
   3.609404700248*^9, 3.609404700906*^9}}],

Cell[BoxData[
 TagBox[
  StyleBox[
   DynamicModuleBox[{$CellContext`BarSizeMins$$ = 3, $CellContext`nTicksPT$$ =
     2, $CellContext`nTicksSL$$ = -6, Typeset`show$$ = True, 
    Typeset`bookmarkList$$ = {}, Typeset`bookmarkMode$$ = "Menu", 
    Typeset`animator$$, Typeset`animvar$$ = 1, Typeset`name$$ = 
    "\"untitled\"", Typeset`specs$$ = {{
      Hold[$CellContext`BarSizeMins$$], {1, 3, 5, 10, 15, 30}}, {
      Hold[$CellContext`nTicksPT$$], 1, 30}, {
      Hold[$CellContext`nTicksSL$$], -2, -30}}, Typeset`size$$ = {
    686., {173., 176.}}, Typeset`update$$ = 0, Typeset`initDone$$, 
    Typeset`skipInitDone$$ = False, $CellContext`BarSizeMins$945082$$ = 
    0, $CellContext`nTicksPT$945083$$ = 0, $CellContext`nTicksSL$945084$$ = 
    0}, 
    DynamicBox[Manipulate`ManipulateBoxes[
     1, StandardForm, 
      "Variables" :> {$CellContext`BarSizeMins$$ = 1, $CellContext`nTicksPT$$ = 
        1, $CellContext`nTicksSL$$ = -2}, "ControllerVariables" :> {
        Hold[$CellContext`BarSizeMins$$, $CellContext`BarSizeMins$945082$$, 
         0], 
        Hold[$CellContext`nTicksPT$$, $CellContext`nTicksPT$945083$$, 0], 
        Hold[$CellContext`nTicksSL$$, $CellContext`nTicksSL$945084$$, 0]}, 
      "OtherVariables" :> {
       Typeset`show$$, Typeset`bookmarkList$$, Typeset`bookmarkMode$$, 
        Typeset`animator$$, Typeset`animvar$$, Typeset`name$$, 
        Typeset`specs$$, Typeset`size$$, Typeset`update$$, Typeset`initDone$$,
         Typeset`skipInitDone$$}, "Body" :> ListPlot[{
         Table[
          Part[
           $CellContext`WinRate[
           1900, $CellContext`Volatility/
            100, $CellContext`BarSizeMins$$, $CellContext`nTicksPT$$, \
$CellContext`nTicksSL$$, 0.25, 12.5, 3], 2], {$CellContext`Volatility, 100}], 
         Table[
          Part[
           $CellContext`WinRateExtreme[
           1900, $CellContext`Volatility/
            100, $CellContext`BarSizeMins$$, $CellContext`nTicksPT$$, \
$CellContext`nTicksSL$$, 0.25, 12.5, 3], 2], {$CellContext`Volatility, 100}]},
         Joined -> True, PlotLegends -> {"Gaussian", "Extreme Value"}, 
        AxesLabel -> {"Volatility %", "Exp. Win Rate (%)"}, PlotLabel -> 
        Style["Expected Win Rate by Volatility - Gaussian vs Extreme Value", 
          FontSize -> 18], ImageSize -> Large], 
      "Specifications" :> {{$CellContext`BarSizeMins$$, {1, 3, 5, 10, 15, 
         30}}, {$CellContext`nTicksPT$$, 1, 
         30}, {$CellContext`nTicksSL$$, -2, -30}}, "Options" :> {}, 
      "DefaultOptions" :> {}],
     ImageSizeCache->{737., {248., 253.}},
     SingleEvaluation->True],
    Deinitialization:>None,
    DynamicModuleValues:>{},
    Initialization:>({{$CellContext`WinRate[
           Pattern[$CellContext`currentPrice, 
            Blank[]], 
           Pattern[$CellContext`annualVolatility, 
            Blank[]], 
           Pattern[$CellContext`BarSizeMins, 
            Blank[]], 
           Pattern[$CellContext`nTicksPT, 
            Blank[]], 
           Pattern[$CellContext`nTicksSL, 
            Blank[]], 
           Pattern[$CellContext`minMove, 
            Blank[]], 
           Pattern[$CellContext`tickValue, 
            Blank[]], 
           Pattern[$CellContext`costContract, 
            Blank[]]] := 
         Module[{$CellContext`nMinsPerDay, $CellContext`periodVolatility, \
$CellContext`tgtReturn, $CellContext`slReturn, $CellContext`tgtDollar, \
$CellContext`slDollar, $CellContext`probWin, $CellContext`probLoss, \
$CellContext`winRate, $CellContext`expWinDollar, $CellContext`expLossDollar, \
$CellContext`expProfit}, $CellContext`nMinsPerDay = (250 6.5) 
             60; $CellContext`periodVolatility = \
$CellContext`annualVolatility/
             Sqrt[$CellContext`nMinsPerDay/$CellContext`BarSizeMins]; \
$CellContext`tgtReturn = $CellContext`nTicksPT \
($CellContext`minMove/$CellContext`currentPrice); $CellContext`tgtDollar = \
$CellContext`nTicksPT $CellContext`tickValue; $CellContext`slReturn = \
$CellContext`nTicksSL ($CellContext`minMove/$CellContext`currentPrice); \
$CellContext`slDollar = $CellContext`nTicksSL $CellContext`tickValue; \
$CellContext`probWin = 1 - CDF[
              NormalDistribution[
              0, $CellContext`periodVolatility], $CellContext`tgtReturn]; \
$CellContext`probLoss = CDF[
              NormalDistribution[
              0, $CellContext`periodVolatility], $CellContext`slReturn]; \
$CellContext`winRate = $CellContext`probWin/($CellContext`probWin + \
$CellContext`probLoss); $CellContext`expWinDollar = $CellContext`tgtDollar \
$CellContext`probWin; $CellContext`expLossDollar = $CellContext`slDollar \
$CellContext`probLoss; $CellContext`expProfit = $CellContext`expWinDollar + \
$CellContext`expLossDollar - $CellContext`costContract; \
{$CellContext`expProfit, $CellContext`winRate}], $CellContext`BarSizeMins$$ := 
         3, $CellContext`nTicksPT$$ := 
         2, $CellContext`nTicksSL$$ := -6, $CellContext`Volatility := 
         0.1, $CellContext`WinRateExtreme[
           Pattern[$CellContext`currentPrice, 
            Blank[]], 
           Pattern[$CellContext`annualVolatility, 
            Blank[]], 
           Pattern[$CellContext`BarSizeMins, 
            Blank[]], 
           Pattern[$CellContext`nTicksPT, 
            Blank[]], 
           Pattern[$CellContext`nTicksSL, 
            Blank[]], 
           Pattern[$CellContext`minMove, 
            Blank[]], 
           Pattern[$CellContext`tickValue, 
            Blank[]], 
           Pattern[$CellContext`costContract, 
            Blank[]]] := 
         Module[{$CellContext`nMinsPerDay, $CellContext`periodVolatility, \
$CellContext`alpha, $CellContext`beta, $CellContext`tgtReturn, \
$CellContext`slReturn, $CellContext`tgtDollar, $CellContext`slDollar, \
$CellContext`probWin, $CellContext`probLoss, $CellContext`winRate, \
$CellContext`expWinDollar, $CellContext`expLossDollar, \
$CellContext`expProfit}, $CellContext`nMinsPerDay = (250 6.5) 
             60; $CellContext`periodVolatility = \
$CellContext`annualVolatility/
             Sqrt[$CellContext`nMinsPerDay/$CellContext`BarSizeMins]; \
$CellContext`beta = 
            Sqrt[6] ($CellContext`periodVolatility/
              Pi); $CellContext`alpha = (-
              EulerGamma) $CellContext`beta; $CellContext`tgtReturn = \
$CellContext`nTicksPT ($CellContext`minMove/$CellContext`currentPrice); \
$CellContext`tgtDollar = $CellContext`nTicksPT $CellContext`tickValue; \
$CellContext`slReturn = $CellContext`nTicksSL \
($CellContext`minMove/$CellContext`currentPrice); $CellContext`slDollar = \
$CellContext`nTicksSL $CellContext`tickValue; $CellContext`probWin = 1 - CDF[
              
              ExtremeValueDistribution[$CellContext`alpha, \
$CellContext`beta], $CellContext`tgtReturn]; $CellContext`probLoss = CDF[
              
              ExtremeValueDistribution[$CellContext`alpha, \
$CellContext`beta], $CellContext`slReturn]; $CellContext`winRate = \
$CellContext`probWin/($CellContext`probWin + $CellContext`probLoss); \
$CellContext`expWinDollar = $CellContext`tgtDollar $CellContext`probWin; \
$CellContext`expLossDollar = $CellContext`slDollar $CellContext`probLoss; \
$CellContext`expProfit = $CellContext`expWinDollar + \
$CellContext`expLossDollar - $CellContext`costContract; \
{$CellContext`expProfit, $CellContext`winRate}]}; Null}; 
     Typeset`initDone$$ = True),
    SynchronousInitialization->True,
    UnsavedVariables:>{Typeset`initDone$$},
    UntrackedVariables:>{Typeset`size$$}], "Manipulate",
   Deployed->True,
   StripOnInput->False],
  Manipulate`InterpretManipulate[1]]], "Output",
 CellChangeTimes->{
  3.609301874873*^9, 3.609302068179*^9, 3.6093023364110003`*^9, 
   3.6093059955559998`*^9, {3.609401980021*^9, 3.609401997545*^9}, {
   3.609402038252*^9, 3.609402083179*^9}, 3.609404670406*^9, 
   3.609404701472*^9}]
}, Open  ]],

Cell["\<\
As you can see, for moderate levels of volatility, up to around 18 % \
annually, the expected Win Rate is actually higher if we assume an Extreme \
Value distribution of returns, rather than a Normal distribution.If we use a \
Normal distribution we will actually underestimate the Win Rate, if the \
actual return distribution is closer to Extreme Value.In other words, the \
assumption of a Gaussian distribution for returns is actually conservative.

Now, on the other hand, it is also the case that at higher levels of \
volatility the assumption of Normality will tend to over - estimate the \
expected Win Rate, if returns actually follow an extreme value distribution.  \
But, as indicated before, for high levels of volatility we need to consider \
amending the scalping strategy very substantially.  Either we need to reverse \
it, setting larger Profit Targets and tighter Stops, or we need to stop \
trading altogether, until volatility declines to normal levels.Many scalpers \
would prefer the second option, as the first alternative doesn't strike them \
as being close enough to scalping to justify the name.If you take that \
approach, i.e.stop trying to scalp in periods when volatility is elevated, \
then the differences in estimated Win Rate resulting from alternative \
assumptions of return distribution are irrelevant.

If you only try to scalp when volatility is under, say, 20 % and you use a \
Gaussian distribution in your scalping model, you will only ever typically \
under - estimate your actual expected Win Rate.In other words, the assumption \
of Normality helps, not hurts, your strategy, by being conservative in its \
estimate of the expected Win Rate.
If, in the alternative, you want to trade the strategy regardless of the \
level of volatility, then by all means use something like an Extreme Value \
distribution in your model, as I have done here.That changes the estimates of \
expected Win Rate that the model produces, but it in no way changes the \
structure of the model, or invalidates it.It' s just a different, arguably \
more realistic set of assumptions pertaining to situations of elevated \
volatility.\
\>", "Text",
 CellChangeTimes->{{3.609402179137*^9, 3.609402261993*^9}, {
   3.6094047250880003`*^9, 3.609404732493*^9}, {3.60940477505*^9, 
   3.609404775174*^9}, 3.60947564377*^9}]
}, Open  ]],

Cell[CellGroupData[{

Cell["Simulation Analysis", "Subtitle",
 CellChangeTimes->{{3.609400954459*^9, 3.609400972759*^9}, {3.609402137424*^9,
   3.6094021415030003`*^9}}],

Cell["\<\
Let' s move on to do some simulation analysis so we can get an understanding \
of the distribution of the expected Win Rate and Avg Trade PL for our two \
alternative models.  We begin by coding a generator that produces a sample of \
1,000 trades and calculates the Avg Trade PL and Win Rate.\
\>", "Text",
 CellChangeTimes->{{3.6094021455109997`*^9, 3.609402147641*^9}, {
  3.609402290218*^9, 3.609402410969*^9}, {3.609404744094*^9, 
  3.609404750398*^9}}],

Cell[CellGroupData[{

Cell["Gaussian Model", "Subsubtitle",
 CellChangeTimes->{{3.6094043387609997`*^9, 3.609404359166*^9}}],

Cell[BoxData[
 RowBox[{
  RowBox[{"GenWinRate", "[", 
   RowBox[{
   "currentPrice_", ",", "annualVolatility_", ",", "BarSizeMins_", ",", " ", 
    "nTicksPT_", ",", " ", "nTicksSL_", ",", "minMove_", ",", " ", 
    "tickValue_", ",", " ", "costContract_"}], "]"}], ":=", 
  RowBox[{"Module", "[", 
   RowBox[{
    RowBox[{"{", " ", 
     RowBox[{
     "nMinsPerDay", ",", " ", "periodVolatility", ",", " ", "randObs", ",", 
      " ", "tgtReturn", ",", " ", "slReturn", ",", "tgtDollar", ",", " ", 
      "slDollar", ",", " ", "nWins", ",", "nLosses", ",", " ", "perTradePL", 
      ",", " ", "probWin", ",", " ", "probLoss", ",", " ", "winRate", ",", 
      " ", "expWinDollar", ",", " ", "expLossDollar", ",", " ", "expProfit"}],
      "}"}], ",", " ", "\[IndentingNewLine]", "\[IndentingNewLine]", 
    RowBox[{
     RowBox[{"nMinsPerDay", " ", "=", " ", 
      RowBox[{"250", "*", "6.5", "*", "60"}]}], ";", "\n", 
     RowBox[{"periodVolatility", " ", "=", " ", 
      RowBox[{"annualVolatility", " ", "/", " ", 
       RowBox[{"Sqrt", "[", 
        RowBox[{"nMinsPerDay", "/", "BarSizeMins"}], "]"}]}]}], ";", "\n", 
     RowBox[{"tgtReturn", "=", 
      RowBox[{"nTicksPT", "*", 
       RowBox[{"minMove", "/", "currentPrice"}]}]}], ";", 
     RowBox[{"tgtDollar", " ", "=", " ", 
      RowBox[{"nTicksPT", " ", "*", " ", "tickValue"}]}], ";", 
     "\[IndentingNewLine]", 
     RowBox[{"slReturn", " ", "=", " ", 
      RowBox[{"nTicksSL", "*", 
       RowBox[{"minMove", "/", "currentPrice"}]}]}], ";", 
     "\[IndentingNewLine]", 
     RowBox[{"slDollar", "=", 
      RowBox[{"nTicksSL", "*", "tickValue"}]}], ";", "\[IndentingNewLine]", 
     "\[IndentingNewLine]", 
     RowBox[{"randObs", "=", 
      RowBox[{"RandomVariate", "[", 
       RowBox[{
        RowBox[{"NormalDistribution", "[", 
         RowBox[{"0", ",", "periodVolatility"}], "]"}], ",", 
        RowBox[{"10", "^", "3"}]}], "]"}]}], ";", "\[IndentingNewLine]", 
     RowBox[{"nWins", "=", 
      RowBox[{"Count", "[", 
       RowBox[{"randObs", ",", 
        RowBox[{"x_", "/;", 
         RowBox[{"x", ">=", "tgtReturn"}]}]}], "]"}]}], ";", 
     "\[IndentingNewLine]", 
     RowBox[{"nLosses", "=", 
      RowBox[{"Count", "[", 
       RowBox[{"randObs", ",", 
        RowBox[{"x_", "/;", 
         RowBox[{"x", "\[LessEqual]", "slReturn"}]}]}], "]"}]}], ";", 
     "\[IndentingNewLine]", 
     RowBox[{"winRate", "=", 
      RowBox[{
       RowBox[{"nWins", "/", 
        RowBox[{"(", 
         RowBox[{"nWins", "+", "nLosses"}], ")"}]}], "//", "N"}]}], ";", 
     "\[IndentingNewLine]", 
     RowBox[{"perTradePL", "=", 
      RowBox[{
       RowBox[{"(", 
        RowBox[{
         RowBox[{"nWins", "*", "tgtDollar"}], "+", 
         RowBox[{"nLosses", "*", "slDollar"}]}], ")"}], "/", 
       RowBox[{"(", 
        RowBox[{"nWins", "+", "nLosses"}], ")"}]}]}], ";", 
     "\[IndentingNewLine]", 
     RowBox[{"{", 
      RowBox[{"perTradePL", ",", "winRate"}], "}"}]}]}], "]"}]}]], "Input",
 CellChangeTimes->{{3.609311237901*^9, 3.609311257164*^9}, {3.609311321204*^9,
   3.609311321676*^9}, {3.609311363016*^9, 3.609311363351*^9}, {
  3.609311404307*^9, 3.6093114463970003`*^9}, {3.6093116088059998`*^9, 
  3.609311724132*^9}, {3.609311757203*^9, 3.609311794043*^9}, {
  3.6093118241*^9, 3.609311824891*^9}, {3.6093118729630003`*^9, 
  3.609311887855*^9}, {3.609311949751*^9, 3.609311978617*^9}, {
  3.6093123557200003`*^9, 3.609312373598*^9}, {3.609312419784*^9, 
  3.6093126247019997`*^9}, {3.609312673367*^9, 3.6093127077869997`*^9}, {
  3.609312756521*^9, 3.609312769291*^9}, {3.609312801542*^9, 
  3.609312824924*^9}, {3.609312906828*^9, 3.609312906967*^9}}],

Cell[CellGroupData[{

Cell[BoxData[
 RowBox[{"GenWinRate", "[", 
  RowBox[{"1900", ",", "0.1", ",", "15", ",", "1", ",", 
   RowBox[{"-", "24"}], ",", "0.25", ",", "12.50", ",", "3"}], "]"}]], "Input",
 CellChangeTimes->{{3.609312695835*^9, 3.609312696134*^9}}],

Cell[BoxData[
 RowBox[{"{", 
  RowBox[{"7.6923076923076925`", ",", "0.9846153846153847`"}], 
  "}"}]], "Output",
 CellChangeTimes->{
  3.609312698776*^9, {3.6093127291540003`*^9, 3.609312733667*^9}, {
   3.609312774328*^9, 3.60931278899*^9}, {3.609312829656*^9, 
   3.609312833207*^9}, 3.609402416252*^9}]
}, Open  ]],

Cell["\<\
Now we can generate a random sample of 10, 000 simulation runs and plot a \
histogram of the Win Rates, using, for example, ES on 5-min bars, with a  PT \
of 2 ticks and SL of - 20 ticks,  assuming annual volatility of 15 %.\
\>", "Text",
 CellChangeTimes->{{3.6094025413640003`*^9, 3.6094026229049997`*^9}, {
   3.609402723108*^9, 3.6094027402200003`*^9}, 3.609404799976*^9}],

Cell[CellGroupData[{

Cell[BoxData[
 RowBox[{"Histogram", "[", 
  RowBox[{
   RowBox[{"Table", "[", 
    RowBox[{
     RowBox[{
      RowBox[{"GenWinRate", "[", 
       RowBox[{"1900", ",", "0.15", ",", "5", ",", "2", ",", 
        RowBox[{"-", "20"}], ",", "0.25", ",", "12.50", ",", "3"}], "]"}], 
      "[", 
      RowBox[{"[", "2", "]"}], "]"}], ",", 
     RowBox[{"{", 
      RowBox[{"i", ",", "10000"}], "}"}]}], "]"}], ",", "10", ",", 
   RowBox[{"AxesLabel", "\[Rule]", 
    RowBox[{"{", "\"\<Exp. Win Rate (%)\>\"", "}"}]}]}], "]"}]], "Input",
 CellChangeTimes->{{3.6093128508459997`*^9, 3.609312960381*^9}, {
   3.609313253184*^9, 3.609313262922*^9}, {3.6093133173129997`*^9, 
   3.6093133177869997`*^9}, {3.609313405901*^9, 3.609313406126*^9}, {
   3.6093134378570004`*^9, 3.609313542258*^9}, {3.609313574099*^9, 
   3.609313597057*^9}, {3.609313910863*^9, 3.6093139111879997`*^9}, 
   3.609313941778*^9, {3.609402459903*^9, 3.609402520009*^9}, {
   3.609402766451*^9, 3.6094027666879997`*^9}, {3.609404511645*^9, 
   3.6094045121400003`*^9}, {3.609404620642*^9, 3.6094046208050003`*^9}}],

Cell[BoxData[
 GraphicsBox[
  {RGBColor[0.798413061722744, 0.824719615472648, 0.968322270542458], 
   EdgeForm[Opacity[0.623]], {}, 
   {RGBColor[0.798413061722744, 0.824719615472648, 0.968322270542458], 
    EdgeForm[Opacity[0.623]], 
    TagBox[
     TooltipBox[
      TagBox[
       DynamicBox[{
         FEPrivate`If[
          CurrentValue["MouseOver"], 
          EdgeForm[{
            GrayLevel[0.5], 
            AbsoluteThickness[1.5], 
            Opacity[0.66]}], {}, {}], 
         RectangleBox[{0.95, 0}, {0.955, 2}, "RoundingRadius" -> 0]},
        ImageSizeCache->{{22.5, 45.76345083487922}, {66.01301038499247, 
         67.1084971874736}}],
       StatusArea[#, 2]& ,
       TagBoxNote->"2"],
      StyleBox["2", {
        GrayLevel[0]}, StripOnInput -> False]],
     Annotation[#, 
      Style[2, {
        GrayLevel[0]}], "Tooltip"]& ], 
    TagBox[
     TooltipBox[
      TagBox[
       DynamicBox[{
         FEPrivate`If[
          CurrentValue["MouseOver"], 
          EdgeForm[{
            GrayLevel[0.5], 
            AbsoluteThickness[1.5], 
            Opacity[0.66]}], {}, {}], 
         RectangleBox[{0.955, 0}, {0.96, 14}, "RoundingRadius" -> 0]},
        ImageSizeCache->{{44.76345083487922, 68.02690166975844}, {
         65.44008957010571, 67.1084971874736}}],
       StatusArea[#, 14]& ,
       TagBoxNote->"14"],
      StyleBox["14", {
        GrayLevel[0]}, StripOnInput -> False]],
     Annotation[#, 
      Style[14, {
        GrayLevel[0]}], "Tooltip"]& ], 
    TagBox[
     TooltipBox[
      TagBox[
       DynamicBox[{
         FEPrivate`If[
          CurrentValue["MouseOver"], 
          EdgeForm[{
            GrayLevel[0.5], 
            AbsoluteThickness[1.5], 
            Opacity[0.66]}], {}, {}], 
         RectangleBox[{0.96, 0}, {0.965, 78}, "RoundingRadius" -> 0]},
        ImageSizeCache->{{67.02690166975844, 90.29035250463767}, {
         62.384511890709625`, 67.1084971874736}}],
       StatusArea[#, 78]& ,
       TagBoxNote->"78"],
      StyleBox["78", {
        GrayLevel[0]}, StripOnInput -> False]],
     Annotation[#, 
      Style[78, {
        GrayLevel[0]}], "Tooltip"]& ], 
    TagBox[
     TooltipBox[
      TagBox[
       DynamicBox[{
         FEPrivate`If[
          CurrentValue["MouseOver"], 
          EdgeForm[{
            GrayLevel[0.5], 
            AbsoluteThickness[1.5], 
            Opacity[0.66]}], {}, {}], 
         RectangleBox[{0.965, 0}, {0.97, 275}, "RoundingRadius" -> 0]},
        ImageSizeCache->{{89.29035250463767, 112.5538033395178}, {
         52.979061846318565`, 67.1084971874736}}],
       StatusArea[#, 275]& ,
       TagBoxNote->"275"],
      StyleBox["275", {
        GrayLevel[0]}, StripOnInput -> False]],
     Annotation[#, 
      Style[275, {
        GrayLevel[0]}], "Tooltip"]& ], 
    TagBox[
     TooltipBox[
      TagBox[
       DynamicBox[{
         FEPrivate`If[
          CurrentValue["MouseOver"], 
          EdgeForm[{
            GrayLevel[0.5], 
            AbsoluteThickness[1.5], 
            Opacity[0.66]}], {}, {}], 
         RectangleBox[{0.97, 0}, {0.975, 844}, "RoundingRadius" -> 0]},
        ImageSizeCache->{{111.5538033395178, 134.81725417439702`}, {
         25.813066540437774`, 67.1084971874736}}],
       StatusArea[#, 844]& ,
       TagBoxNote->"844"],
      StyleBox["844", {
        GrayLevel[0]}, StripOnInput -> False]],
     Annotation[#, 
      Style[844, {
        GrayLevel[0]}], "Tooltip"]& ], 
    TagBox[
     TooltipBox[
      TagBox[
       DynamicBox[{
         FEPrivate`If[
          CurrentValue["MouseOver"], 
          EdgeForm[{
            GrayLevel[0.5], 
            AbsoluteThickness[1.5], 
            Opacity[0.66]}], {}, {}], 
         RectangleBox[{0.975, 0}, {0.98, 1985}, "RoundingRadius" -> 0]},
        ImageSizeCache->{{133.81725417439702`, 
         157.08070500927624`}, {-28.66215427504551, 67.1084971874736}}],
       StatusArea[#, 1985]& ,
       TagBoxNote->"1985"],
      StyleBox["1985", {
        GrayLevel[0]}, StripOnInput -> False]],
     Annotation[#, 
      Style[1985, {
        GrayLevel[0]}], "Tooltip"]& ], 
    TagBox[
     TooltipBox[
      TagBox[
       DynamicBox[{
         FEPrivate`If[
          CurrentValue["MouseOver"], 
          EdgeForm[{
            GrayLevel[0.5], 
            AbsoluteThickness[1.5], 
            Opacity[0.66]}], {}, {}], 
         RectangleBox[{0.98, 0}, {0.985, 2906}, "RoundingRadius" -> 0]},
        ImageSizeCache->{{156.08070500927624`, 
         179.34415584415547`}, {-72.63382681760476, 67.1084971874736}}],
       StatusArea[#, 2906]& ,
       TagBoxNote->"2906"],
      StyleBox["2906", {
        GrayLevel[0]}, StripOnInput -> False]],
     Annotation[#, 
      Style[2906, {
        GrayLevel[0]}], "Tooltip"]& ], 
    TagBox[
     TooltipBox[
      TagBox[
       DynamicBox[{
         FEPrivate`If[
          CurrentValue["MouseOver"], 
          EdgeForm[{
            GrayLevel[0.5], 
            AbsoluteThickness[1.5], 
            Opacity[0.66]}], {}, {}], 
         RectangleBox[{0.985, 0}, {0.99, 2589}, "RoundingRadius" -> 0]},
        ImageSizeCache->{{178.34415584415547`, 
         201.6076066790356}, {-57.49916862434603, 67.1084971874736}}],
       StatusArea[#, 2589]& ,
       TagBoxNote->"2589"],
      StyleBox["2589", {
        GrayLevel[0]}, StripOnInput -> False]],
     Annotation[#, 
      Style[2589, {
        GrayLevel[0]}], "Tooltip"]& ], 
    TagBox[
     TooltipBox[
      TagBox[
       DynamicBox[{
         FEPrivate`If[
          CurrentValue["MouseOver"], 
          EdgeForm[{
            GrayLevel[0.5], 
            AbsoluteThickness[1.5], 
            Opacity[0.66]}], {}, {}], 
         RectangleBox[{0.99, 0}, {0.995, 1124}, "RoundingRadius" -> 0]},
        ImageSizeCache->{{200.6076066790356, 223.87105751391482`}, {
         12.44491419307991, 67.1084971874736}}],
       StatusArea[#, 1124]& ,
       TagBoxNote->"1124"],
      StyleBox["1124", {
        GrayLevel[0]}, StripOnInput -> False]],
     Annotation[#, 
      Style[1124, {
        GrayLevel[0]}], "Tooltip"]& ], 
    TagBox[
     TooltipBox[
      TagBox[
       DynamicBox[{
         FEPrivate`If[
          CurrentValue["MouseOver"], 
          EdgeForm[{
            GrayLevel[0.5], 
            AbsoluteThickness[1.5], 
            Opacity[0.66]}], {}, {}], 
         RectangleBox[{0.995, 0}, {1., 177}, "RoundingRadius" -> 0]},
        ImageSizeCache->{{222.87105751391482`, 246.13450834879404`}, {
         57.65791516789381, 67.1084971874736}}],
       StatusArea[#, 177]& ,
       TagBoxNote->"177"],
      StyleBox["177", {
        GrayLevel[0]}, StripOnInput -> False]],
     Annotation[#, 
      Style[177, {
        GrayLevel[0]}], "Tooltip"]& ], 
    TagBox[
     TooltipBox[
      TagBox[
       DynamicBox[{
         FEPrivate`If[
          CurrentValue["MouseOver"], 
          EdgeForm[{
            GrayLevel[0.5], 
            AbsoluteThickness[1.5], 
            Opacity[0.66]}], {}, {}], 
         RectangleBox[{1., 0}, {1.005, 6}, "RoundingRadius" -> 0]},
        ImageSizeCache->{{245.13450834879404`, 268.39795918367327`}, {
         65.82203678003022, 67.1084971874736}}],
       StatusArea[#, 6]& ,
       TagBoxNote->"6"],
      StyleBox["6", {
        GrayLevel[0]}, StripOnInput -> False]],
     Annotation[#, 
      Style[6, {
        GrayLevel[0]}], "Tooltip"]& ]}, {}, {}},
  AspectRatio->NCache[GoldenRatio^(-1), 0.6180339887498948],
  Axes->{True, True},
  AxesLabel->{
    FormBox["\"Exp. Win Rate (%)\"", TraditionalForm], None},
  AxesOrigin->{0.95, 0},
  FrameTicks->{{Automatic, Automatic}, {Automatic, Automatic}},
  GridLines->{None, None},
  PlotRange->{{0.95, 1.005}, {All, All}},
  PlotRangePadding->{{
     Scaled[0.02], 
     Scaled[0.02]}, {
     Scaled[0.02], 
     Scaled[0.1]}},
  Ticks->{Automatic, Automatic}]], "Output",
 CellChangeTimes->{
  3.609312888009*^9, {3.6093129211730003`*^9, 3.6093129749519997`*^9}, 
   3.609313277466*^9, 3.60931333256*^9, 3.609313420729*^9, {
   3.6093134522530003`*^9, 3.6093135567939997`*^9}, {3.609313590506*^9, 
   3.609313611823*^9}, {3.6093139280480003`*^9, 3.609313956347*^9}, {
   3.6094024546400003`*^9, 3.6094025375290003`*^9}, 3.6094027815220003`*^9, 
   3.609404527359*^9, 3.6094046381619997`*^9}]
}, Open  ]],

Cell[CellGroupData[{

Cell[BoxData[
 RowBox[{"Histogram", "[", 
  RowBox[{
   RowBox[{"Table", "[", 
    RowBox[{
     RowBox[{
      RowBox[{"GenWinRate", "[", 
       RowBox[{"1900", ",", "0.15", ",", "5", ",", "2", ",", 
        RowBox[{"-", "20"}], ",", "0.25", ",", "12.50", ",", "3"}], "]"}], 
      "[", 
      RowBox[{"[", "1", "]"}], "]"}], ",", 
     RowBox[{"{", 
      RowBox[{"i", ",", "10000"}], "}"}]}], "]"}], ",", "10", ",", 
   RowBox[{"AxesLabel", "\[Rule]", 
    RowBox[{"{", "\"\<Exp. PL/Trade ($)\>\"", "}"}]}]}], "]"}]], "Input",
 CellChangeTimes->{{3.609404554271*^9, 3.609404570894*^9}, {3.609404608677*^9,
   3.609404608926*^9}}],

Cell[BoxData[
 GraphicsBox[
  {RGBColor[0.798413061722744, 0.824719615472648, 0.968322270542458], 
   EdgeForm[Opacity[0.602]], {}, 
   {RGBColor[0.798413061722744, 0.824719615472648, 0.968322270542458], 
    EdgeForm[Opacity[0.602]], 
    TagBox[
     TooltipBox[
      TagBox[
       DynamicBox[{
         FEPrivate`If[
          CurrentValue["MouseOver"], 
          EdgeForm[{
            GrayLevel[0.5], 
            AbsoluteThickness[1.5], 
            Opacity[0.66]}], {}, {}], 
         RectangleBox[{12., 0}, {13., 4}, "RoundingRadius" -> 0]},
        ImageSizeCache->{{22.50000000000003, 41.20262390670558}, {
         67.72299636892276, 68.96259915372335}}],
       StatusArea[#, 4]& ,
       TagBoxNote->"4"],
      StyleBox["4", {
        GrayLevel[0]}, StripOnInput -> False]],
     Annotation[#, 
      Style[4, {
        GrayLevel[0]}], "Tooltip"]& ], 
    TagBox[
     TooltipBox[
      TagBox[
       DynamicBox[{
         FEPrivate`If[
          CurrentValue["MouseOver"], 
          EdgeForm[{
            GrayLevel[0.5], 
            AbsoluteThickness[1.5], 
            Opacity[0.66]}], {}, {}], 
         RectangleBox[{13., 0}, {14., 6}, "RoundingRadius" -> 0]},
        ImageSizeCache->{{40.20262390670558, 58.90524781341111}, {
         67.60319497652247, 68.96259915372335}}],
       StatusArea[#, 6]& ,
       TagBoxNote->"6"],
      StyleBox["6", {
        GrayLevel[0]}, StripOnInput -> False]],
     Annotation[#, 
      Style[6, {
        GrayLevel[0]}], "Tooltip"]& ], 
    TagBox[
     TooltipBox[
      TagBox[
       DynamicBox[{
         FEPrivate`If[
          CurrentValue["MouseOver"], 
          EdgeForm[{
            GrayLevel[0.5], 
            AbsoluteThickness[1.5], 
            Opacity[0.66]}], {}, {}], 
         RectangleBox[{14., 0}, {15., 27}, "RoundingRadius" -> 0]},
        ImageSizeCache->{{57.90524781341111, 76.60787172011666}, {
         66.34528035631944, 68.96259915372335}}],
       StatusArea[#, 27]& ,
       TagBoxNote->"27"],
      StyleBox["27", {
        GrayLevel[0]}, StripOnInput -> False]],
     Annotation[#, 
      Style[27, {
        GrayLevel[0]}], "Tooltip"]& ], 
    TagBox[
     TooltipBox[
      TagBox[
       DynamicBox[{
         FEPrivate`If[
          CurrentValue["MouseOver"], 
          EdgeForm[{
            GrayLevel[0.5], 
            AbsoluteThickness[1.5], 
            Opacity[0.66]}], {}, {}], 
         RectangleBox[{15., 0}, {16., 103}, "RoundingRadius" -> 0]},
        ImageSizeCache->{{75.60787172011666, 94.31049562682219}, {
         61.792827445108436`, 68.96259915372335}}],
       StatusArea[#, 103]& ,
       TagBoxNote->"103"],
      StyleBox["103", {
        GrayLevel[0]}, StripOnInput -> False]],
     Annotation[#, 
      Style[103, {
        GrayLevel[0]}], "Tooltip"]& ], 
    TagBox[
     TooltipBox[
      TagBox[
       DynamicBox[{
         FEPrivate`If[
          CurrentValue["MouseOver"], 
          EdgeForm[{
            GrayLevel[0.5], 
            AbsoluteThickness[1.5], 
            Opacity[0.66]}], {}, {}], 
         RectangleBox[{16., 0}, {17., 316}, "RoundingRadius" -> 0]},
        ImageSizeCache->{{93.31049562682219, 112.01311953352771`}, {
         49.0339791544776, 68.96259915372335}}],
       StatusArea[#, 316]& ,
       TagBoxNote->"316"],
      StyleBox["316", {
        GrayLevel[0]}, StripOnInput -> False]],
     Annotation[#, 
      Style[316, {
        GrayLevel[0]}], "Tooltip"]& ], 
    TagBox[
     TooltipBox[
      TagBox[
       DynamicBox[{
         FEPrivate`If[
          CurrentValue["MouseOver"], 
          EdgeForm[{
            GrayLevel[0.5], 
            AbsoluteThickness[1.5], 
            Opacity[0.66]}], {}, {}], 
         RectangleBox[{17., 0}, {18., 642}, "RoundingRadius" -> 0]},
        ImageSizeCache->{{111.01311953352771`, 129.71574344023324`}, {
         29.506352193230406`, 68.96259915372335}}],
       StatusArea[#, 642]& ,
       TagBoxNote->"642"],
      StyleBox["642", {
        GrayLevel[0]}, StripOnInput -> False]],
     Annotation[#, 
      Style[642, {
        GrayLevel[0]}], "Tooltip"]& ], 
    TagBox[
     TooltipBox[
      TagBox[
       DynamicBox[{
         FEPrivate`If[
          CurrentValue["MouseOver"], 
          EdgeForm[{
            GrayLevel[0.5], 
            AbsoluteThickness[1.5], 
            Opacity[0.66]}], {}, {}], 
         RectangleBox[{18., 0}, {19., 1258}, "RoundingRadius" -> 0]},
        ImageSizeCache->{{128.71574344023324`, 
         147.41836734693882`}, {-7.3924766660587835`, 68.96259915372335}}],
       StatusArea[#, 1258]& ,
       TagBoxNote->"1258"],
      StyleBox["1258", {
        GrayLevel[0]}, StripOnInput -> False]],
     Annotation[#, 
      Style[1258, {
        GrayLevel[0]}], "Tooltip"]& ], 
    TagBox[
     TooltipBox[
      TagBox[
       DynamicBox[{
         FEPrivate`If[
          CurrentValue["MouseOver"], 
          EdgeForm[{
            GrayLevel[0.5], 
            AbsoluteThickness[1.5], 
            Opacity[0.66]}], {}, {}], 
         RectangleBox[{19., 0}, {20., 1860}, "RoundingRadius" -> 0]},
        ImageSizeCache->{{146.41836734693882`, 
         165.12099125364435`}, {-43.45269577854593, 68.96259915372335}}],
       StatusArea[#, 1860]& ,
       TagBoxNote->"1860"],
      StyleBox["1860", {
        GrayLevel[0]}, StripOnInput -> False]],
     Annotation[#, 
      Style[1860, {
        GrayLevel[0]}], "Tooltip"]& ], 
    TagBox[
     TooltipBox[
      TagBox[
       DynamicBox[{
         FEPrivate`If[
          CurrentValue["MouseOver"], 
          EdgeForm[{
            GrayLevel[0.5], 
            AbsoluteThickness[1.5], 
            Opacity[0.66]}], {}, {}], 
         RectangleBox[{20., 0}, {21., 2344}, "RoundingRadius" -> 0]},
        ImageSizeCache->{{164.12099125364435`, 
         182.82361516034987`}, {-72.444632739416, 68.96259915372335}}],
       StatusArea[#, 2344]& ,
       TagBoxNote->"2344"],
      StyleBox["2344", {
        GrayLevel[0]}, StripOnInput -> False]],
     Annotation[#, 
      Style[2344, {
        GrayLevel[0]}], "Tooltip"]& ], 
    TagBox[
     TooltipBox[
      TagBox[
       DynamicBox[{
         FEPrivate`If[
          CurrentValue["MouseOver"], 
          EdgeForm[{
            GrayLevel[0.5], 
            AbsoluteThickness[1.5], 
            Opacity[0.66]}], {}, {}], 
         RectangleBox[{21., 0}, {22., 1853}, "RoundingRadius" -> 0]},
        ImageSizeCache->{{181.82361516034987`, 
         200.5262390670554}, {-43.03339090514491, 68.96259915372335}}],
       StatusArea[#, 1853]& ,
       TagBoxNote->"1853"],
      StyleBox["1853", {
        GrayLevel[0]}, StripOnInput -> False]],
     Annotation[#, 
      Style[1853, {
        GrayLevel[0]}], "Tooltip"]& ], 
    TagBox[
     TooltipBox[
      TagBox[
       DynamicBox[{
         FEPrivate`If[
          CurrentValue["MouseOver"], 
          EdgeForm[{
            GrayLevel[0.5], 
            AbsoluteThickness[1.5], 
            Opacity[0.66]}], {}, {}], 
         RectangleBox[{22., 0}, {23., 1132}, "RoundingRadius" -> 0]},
        ImageSizeCache->{{199.5262390670554, 218.22886297376093`}, {
         0.15501105515946279`, 68.96259915372335}}],
       StatusArea[#, 1132]& ,
       TagBoxNote->"1132"],
      StyleBox["1132", {
        GrayLevel[0]}, StripOnInput -> False]],
     Annotation[#, 
      Style[1132, {
        GrayLevel[0]}], "Tooltip"]& ], 
    TagBox[
     TooltipBox[
      TagBox[
       DynamicBox[{
         FEPrivate`If[
          CurrentValue["MouseOver"], 
          EdgeForm[{
            GrayLevel[0.5], 
            AbsoluteThickness[1.5], 
            Opacity[0.66]}], {}, {}], 
         RectangleBox[{23., 0}, {24., 402}, "RoundingRadius" -> 0]},
        ImageSizeCache->{{217.22886297376093`, 235.93148688046645`}, {
         43.88251928126515, 68.96259915372335}}],
       StatusArea[#, 402]& ,
       TagBoxNote->"402"],
      StyleBox["402", {
        GrayLevel[0]}, StripOnInput -> False]],
     Annotation[#, 
      Style[402, {
        GrayLevel[0]}], "Tooltip"]& ], 
    TagBox[
     TooltipBox[
      TagBox[
       DynamicBox[{
         FEPrivate`If[
          CurrentValue["MouseOver"], 
          EdgeForm[{
            GrayLevel[0.5], 
            AbsoluteThickness[1.5], 
            Opacity[0.66]}], {}, {}], 
         RectangleBox[{24., 0}, {25., 48}, "RoundingRadius" -> 0]},
        ImageSizeCache->{{234.93148688046645`, 253.63411078717203`}, {
         65.0873657361164, 68.96259915372335}}],
       StatusArea[#, 48]& ,
       TagBoxNote->"48"],
      StyleBox["48", {
        GrayLevel[0]}, StripOnInput -> False]],
     Annotation[#, 
      Style[48, {
        GrayLevel[0]}], "Tooltip"]& ], 
    TagBox[
     TooltipBox[
      TagBox[
       DynamicBox[{
         FEPrivate`If[
          CurrentValue["MouseOver"], 
          EdgeForm[{
            GrayLevel[0.5], 
            AbsoluteThickness[1.5], 
            Opacity[0.66]}], {}, {}], 
         RectangleBox[{25., 0}, {26., 5}, "RoundingRadius" -> 0]},
        ImageSizeCache->{{252.63411078717203`, 271.3367346938776}, {
         67.66309567272262, 68.96259915372335}}],
       StatusArea[#, 5]& ,
       TagBoxNote->"5"],
      StyleBox["5", {
        GrayLevel[0]}, StripOnInput -> False]],
     Annotation[#, 
      Style[5, {
        GrayLevel[0]}], "Tooltip"]& ]}, {}, {}},
  AspectRatio->NCache[GoldenRatio^(-1), 0.6180339887498948],
  Axes->{True, True},
  AxesLabel->{
    FormBox["\"Exp. PL/Trade ($)\"", TraditionalForm], None},
  AxesOrigin->{12., 0},
  FrameTicks->{{Automatic, Automatic}, {Automatic, Automatic}},
  GridLines->{None, None},
  PlotRange->{{12., 26.}, {All, All}},
  PlotRangePadding->{{
     Scaled[0.02], 
     Scaled[0.02]}, {
     Scaled[0.02], 
     Scaled[0.1]}},
  Ticks->{Automatic, Automatic}]], "Output",
 CellChangeTimes->{3.6094045866210003`*^9, 3.609404623809*^9}]
}, Open  ]]
}, Open  ]],

Cell[CellGroupData[{

Cell["\<\
Extreme Value Distribution Model\
\>", "Subsubtitle",
 CellChangeTimes->{{3.609404367519*^9, 3.60940439546*^9}}],

Cell["\<\
Next we can do the same for the Extreme Value Distribution version of the \
model.\
\>", "Text",
 CellChangeTimes->{{3.609402628427*^9, 3.6094026594560003`*^9}}],

Cell[BoxData[
 RowBox[{
  RowBox[{"GenWinRateExtreme", "[", 
   RowBox[{
   "currentPrice_", ",", "annualVolatility_", ",", "BarSizeMins_", ",", " ", 
    "nTicksPT_", ",", " ", "nTicksSL_", ",", "minMove_", ",", " ", 
    "tickValue_", ",", " ", "costContract_"}], "]"}], ":=", 
  RowBox[{"Module", "[", 
   RowBox[{
    RowBox[{"{", " ", 
     RowBox[{
     "nMinsPerDay", ",", " ", "periodVolatility", ",", " ", "randObs", ",", 
      " ", "tgtReturn", ",", " ", "slReturn", ",", "tgtDollar", ",", " ", 
      "slDollar", ",", " ", "alpha", ",", " ", "beta", ",", "nWins", ",", 
      "nLosses", ",", " ", "perTradePL", ",", " ", "probWin", ",", " ", 
      "probLoss", ",", " ", "winRate", ",", " ", "expWinDollar", ",", " ", 
      "expLossDollar", ",", " ", "expProfit"}], "}"}], ",", " ", 
    "\[IndentingNewLine]", "\[IndentingNewLine]", 
    RowBox[{
     RowBox[{"nMinsPerDay", " ", "=", " ", 
      RowBox[{"250", "*", "6.5", "*", "60"}]}], ";", "\n", 
     RowBox[{"periodVolatility", " ", "=", " ", 
      RowBox[{"annualVolatility", " ", "/", " ", 
       RowBox[{"Sqrt", "[", 
        RowBox[{"nMinsPerDay", "/", "BarSizeMins"}], "]"}]}]}], ";", 
     "\[IndentingNewLine]", 
     RowBox[{"beta", " ", "=", " ", 
      RowBox[{
       RowBox[{"Sqrt", "[", "6", "]"}], "*", 
       RowBox[{"periodVolatility", " ", "/", " ", "Pi"}]}]}], ";", 
     "\[IndentingNewLine]", 
     RowBox[{"alpha", "=", 
      RowBox[{
       RowBox[{"-", "EulerGamma"}], "*", "beta"}]}], ";", "\n", 
     RowBox[{"tgtReturn", "=", 
      RowBox[{"nTicksPT", "*", 
       RowBox[{"minMove", "/", "currentPrice"}]}]}], ";", 
     RowBox[{"tgtDollar", " ", "=", " ", 
      RowBox[{"nTicksPT", " ", "*", " ", "tickValue"}]}], ";", 
     "\[IndentingNewLine]", 
     RowBox[{"slReturn", " ", "=", " ", 
      RowBox[{"nTicksSL", "*", 
       RowBox[{"minMove", "/", "currentPrice"}]}]}], ";", 
     "\[IndentingNewLine]", 
     RowBox[{"slDollar", "=", 
      RowBox[{"nTicksSL", "*", "tickValue"}]}], ";", "\[IndentingNewLine]", 
     "\[IndentingNewLine]", 
     RowBox[{"randObs", "=", 
      RowBox[{"RandomVariate", "[", 
       RowBox[{
        RowBox[{"ExtremeValueDistribution", "[", 
         RowBox[{"alpha", ",", " ", "beta"}], "]"}], ",", 
        RowBox[{"10", "^", "3"}]}], "]"}]}], ";", "\[IndentingNewLine]", 
     RowBox[{"nWins", "=", 
      RowBox[{"Count", "[", 
       RowBox[{"randObs", ",", 
        RowBox[{"x_", "/;", 
         RowBox[{"x", ">=", "tgtReturn"}]}]}], "]"}]}], ";", 
     "\[IndentingNewLine]", 
     RowBox[{"nLosses", "=", 
      RowBox[{"Count", "[", 
       RowBox[{"randObs", ",", 
        RowBox[{"x_", "/;", 
         RowBox[{"x", "\[LessEqual]", "slReturn"}]}]}], "]"}]}], ";", 
     "\[IndentingNewLine]", 
     RowBox[{"winRate", "=", 
      RowBox[{
       RowBox[{"nWins", "/", 
        RowBox[{"(", 
         RowBox[{"nWins", "+", "nLosses"}], ")"}]}], "//", "N"}]}], ";", 
     "\[IndentingNewLine]", 
     RowBox[{"perTradePL", "=", 
      RowBox[{
       RowBox[{"(", 
        RowBox[{
         RowBox[{"nWins", "*", "tgtDollar"}], "+", 
         RowBox[{"nLosses", "*", "slDollar"}]}], ")"}], "/", 
       RowBox[{"(", 
        RowBox[{"nWins", "+", "nLosses"}], ")"}]}]}], ";", 
     "\[IndentingNewLine]", 
     RowBox[{"{", 
      RowBox[{"perTradePL", ",", "winRate"}], "}"}]}]}], "]"}]}]], "Input",
 CellChangeTimes->{{3.6093130072390003`*^9, 3.6093130086429996`*^9}, {
   3.609313042995*^9, 3.609313055781*^9}, 3.6093130939040003`*^9}],

Cell[CellGroupData[{

Cell[BoxData[
 RowBox[{"Histogram", "[", 
  RowBox[{
   RowBox[{"Table", "[", 
    RowBox[{
     RowBox[{
      RowBox[{"GenWinRateExtreme", "[", 
       RowBox[{"1900", ",", "0.15", ",", "5", ",", "2", ",", 
        RowBox[{"-", "10"}], ",", "0.25", ",", "12.50", ",", "3"}], "]"}], 
      "[", 
      RowBox[{"[", "2", "]"}], "]"}], ",", 
     RowBox[{"{", 
      RowBox[{"i", ",", "10000"}], "}"}]}], "]"}], ",", "10", ",", 
   RowBox[{"AxesLabel", "\[Rule]", 
    RowBox[{"{", "\"\<Exp. Win Rate (%)\>\"", "}"}]}]}], "]"}]], "Input",
 CellChangeTimes->{{3.60931310804*^9, 3.60931310913*^9}, {3.609313149113*^9, 
   3.609313220164*^9}, {3.609313293376*^9, 3.6093132938129997`*^9}, {
   3.6093133530150003`*^9, 3.6093133813719997`*^9}, {3.609313620311*^9, 
   3.609313620723*^9}, {3.609313723568*^9, 3.609313773693*^9}, {
   3.609313805101*^9, 3.609313826866*^9}, {3.609313868226*^9, 
   3.6093138812209997`*^9}, {3.609314023236*^9, 3.609314023461*^9}, {
   3.6093143229110003`*^9, 3.609314333237*^9}, {3.609314703774*^9, 
   3.609314703999*^9}, {3.6093147382720003`*^9, 3.609314738696*^9}, {
   3.609314790829*^9, 3.609314791079*^9}, {3.609314865698*^9, 
   3.6093148660480003`*^9}, {3.609314958014*^9, 3.609314958413*^9}, {
   3.609315089891*^9, 3.609315098117*^9}, {3.609315342907*^9, 
   3.609315356645*^9}, {3.6093154040299997`*^9, 3.609315404417*^9}, {
   3.6093155630699997`*^9, 3.609315563358*^9}, 3.609315665473*^9, 
   3.609315740392*^9, {3.6094026656429996`*^9, 3.609402669543*^9}, {
   3.60940270473*^9, 3.609402707167*^9}, {3.609402746484*^9, 
   3.609402746697*^9}}],

Cell[BoxData[
 GraphicsBox[
  {RGBColor[0.798413061722744, 0.824719615472648, 0.968322270542458], 
   EdgeForm[Opacity[0.644]], {}, 
   {RGBColor[0.798413061722744, 0.824719615472648, 0.968322270542458], 
    EdgeForm[Opacity[0.644]], 
    TagBox[
     TooltipBox[
      TagBox[
       DynamicBox[{
         FEPrivate`If[
          CurrentValue["MouseOver"], 
          EdgeForm[{
            GrayLevel[0.5], 
            AbsoluteThickness[1.5], 
            Opacity[0.66]}], {}, {}], 
         RectangleBox[{0.76, 0}, {0.78, 32}, "RoundingRadius" -> 0]},
        ImageSizeCache->{{22.5, 54.112244897959044`}, {65.00105035081553, 
         67.10849718747367}}],
       StatusArea[#, 32]& ,
       TagBoxNote->"32"],
      StyleBox["32", {
        GrayLevel[0]}, StripOnInput -> False]],
     Annotation[#, 
      Style[32, {
        GrayLevel[0]}], "Tooltip"]& ], 
    TagBox[
     TooltipBox[
      TagBox[
       DynamicBox[{
         FEPrivate`If[
          CurrentValue["MouseOver"], 
          EdgeForm[{
            GrayLevel[0.5], 
            AbsoluteThickness[1.5], 
            Opacity[0.66]}], {}, {}], 
         RectangleBox[{0.78, 0}, {0.8, 333}, "RoundingRadius" -> 0]},
        ImageSizeCache->{{53.112244897959044`, 84.72448979591832}, {
         54.58412854349984, 67.10849718747367}}],
       StatusArea[#, 333]& ,
       TagBoxNote->"333"],
      StyleBox["333", {
        GrayLevel[0]}, StripOnInput -> False]],
     Annotation[#, 
      Style[333, {
        GrayLevel[0]}], "Tooltip"]& ], 
    TagBox[
     TooltipBox[
      TagBox[
       DynamicBox[{
         FEPrivate`If[
          CurrentValue["MouseOver"], 
          EdgeForm[{
            GrayLevel[0.5], 
            AbsoluteThickness[1.5], 
            Opacity[0.66]}], {}, {}], 
         RectangleBox[{0.8, 0}, {0.82, 1884}, "RoundingRadius" -> 0]},
        ImageSizeCache->{{83.72448979591832, 115.33673469387736`}, {
         0.9075646792253167, 67.10849718747367}}],
       StatusArea[#, 1884]& ,
       TagBoxNote->"1884"],
      StyleBox["1884", {
        GrayLevel[0]}, StripOnInput -> False]],
     Annotation[#, 
      Style[1884, {
        GrayLevel[0]}], "Tooltip"]& ], 
    TagBox[
     TooltipBox[
      TagBox[
       DynamicBox[{
         FEPrivate`If[
          CurrentValue["MouseOver"], 
          EdgeForm[{
            GrayLevel[0.5], 
            AbsoluteThickness[1.5], 
            Opacity[0.66]}], {}, {}], 
         RectangleBox[{0.82, 0}, {0.84, 4009}, "RoundingRadius" -> 0]},
        ImageSizeCache->{{114.33673469387736`, 
         145.94897959183663`}, {-72.63382681760471, 67.10849718747367}}],
       StatusArea[#, 4009]& ,
       TagBoxNote->"4009"],
      StyleBox["4009", {
        GrayLevel[0]}, StripOnInput -> False]],
     Annotation[#, 
      Style[4009, {
        GrayLevel[0]}], "Tooltip"]& ], 
    TagBox[
     TooltipBox[
      TagBox[
       DynamicBox[{
         FEPrivate`If[
          CurrentValue["MouseOver"], 
          EdgeForm[{
            GrayLevel[0.5], 
            AbsoluteThickness[1.5], 
            Opacity[0.66]}], {}, {}], 
         RectangleBox[{0.84, 0}, {0.86, 2972}, "RoundingRadius" -> 0]},
        ImageSizeCache->{{144.94897959183663`, 
         176.5612244897959}, {-36.74562776715166, 67.10849718747367}}],
       StatusArea[#, 2972]& ,
       TagBoxNote->"2972"],
      StyleBox["2972", {
        GrayLevel[0]}, StripOnInput -> False]],
     Annotation[#, 
      Style[2972, {
        GrayLevel[0]}], "Tooltip"]& ], 
    TagBox[
     TooltipBox[
      TagBox[
       DynamicBox[{
         FEPrivate`If[
          CurrentValue["MouseOver"], 
          EdgeForm[{
            GrayLevel[0.5], 
            AbsoluteThickness[1.5], 
            Opacity[0.66]}], {}, {}], 
         RectangleBox[{0.86, 0}, {0.88, 708}, "RoundingRadius" -> 0]},
        ImageSizeCache->{{175.5612244897959, 207.17346938775495`}, {
         41.60623592641219, 67.10849718747367}}],
       StatusArea[#, 708]& ,
       TagBoxNote->"708"],
      StyleBox["708", {
        GrayLevel[0]}, StripOnInput -> False]],
     Annotation[#, 
      Style[708, {
        GrayLevel[0]}], "Tooltip"]& ], 
    TagBox[
     TooltipBox[
      TagBox[
       DynamicBox[{
         FEPrivate`If[
          CurrentValue["MouseOver"], 
          EdgeForm[{
            GrayLevel[0.5], 
            AbsoluteThickness[1.5], 
            Opacity[0.66]}], {}, {}], 
         RectangleBox[{0.88, 0}, {0.9, 61}, "RoundingRadius" -> 0]},
        ImageSizeCache->{{206.17346938775495`, 237.78571428571422`}, {
         63.99742665509409, 67.10849718747367}}],
       StatusArea[#, 61]& ,
       TagBoxNote->"61"],
      StyleBox["61", {
        GrayLevel[0]}, StripOnInput -> False]],
     Annotation[#, 
      Style[61, {
        GrayLevel[0]}], "Tooltip"]& ], 
    TagBox[
     TooltipBox[
      TagBox[
       DynamicBox[{
         FEPrivate`If[
          CurrentValue["MouseOver"], 
          EdgeForm[{
            GrayLevel[0.5], 
            AbsoluteThickness[1.5], 
            Opacity[0.66]}], {}, {}], 
         RectangleBox[{0.9, 0}, {0.92, 1}, "RoundingRadius" -> 0]},
        ImageSizeCache->{{236.78571428571422`, 268.3979591836735}, {
         66.0738894738281, 67.10849718747367}}],
       StatusArea[#, 1]& ,
       TagBoxNote->"1"],
      StyleBox["1", {
        GrayLevel[0]}, StripOnInput -> False]],
     Annotation[#, 
      Style[1, {
        GrayLevel[0]}], "Tooltip"]& ]}, {}, {}},
  AspectRatio->NCache[GoldenRatio^(-1), 0.6180339887498948],
  Axes->{True, True},
  AxesLabel->{
    FormBox["\"Exp. Win Rate (%)\"", TraditionalForm], None},
  AxesOrigin->{0.76, 0},
  FrameTicks->{{Automatic, Automatic}, {Automatic, Automatic}},
  GridLines->{None, None},
  PlotRange->{{0.76, 0.92}, {All, All}},
  PlotRangePadding->{{
     Scaled[0.02], 
     Scaled[0.02]}, {
     Scaled[0.02], 
     Scaled[0.1]}},
  Ticks->{Automatic, Automatic}]], "Output",
 CellChangeTimes->{
  3.6093149173190002`*^9, 3.6093149837720003`*^9, 3.609315128716*^9, {
   3.609315401078*^9, 3.609315423953*^9}, 3.609315578554*^9, 
   3.6093156855030003`*^9, 3.6093157564110003`*^9, 3.609402690132*^9, 
   3.6094027271949997`*^9, 3.6094027618459997`*^9}]
}, Open  ]],

Cell[CellGroupData[{

Cell[BoxData[
 RowBox[{"Histogram", "[", 
  RowBox[{
   RowBox[{"Table", "[", 
    RowBox[{
     RowBox[{
      RowBox[{"GenWinRateExtreme", "[", 
       RowBox[{"1900", ",", "0.15", ",", "5", ",", "2", ",", 
        RowBox[{"-", "10"}], ",", "0.25", ",", "12.50", ",", "3"}], "]"}], 
      "[", 
      RowBox[{"[", "1", "]"}], "]"}], ",", 
     RowBox[{"{", 
      RowBox[{"i", ",", "10000"}], "}"}]}], "]"}], ",", "10", ",", 
   RowBox[{"AxesLabel", "\[Rule]", 
    RowBox[{"{", "\"\<Exp. PL/Trade ($)\>\"", "}"}]}]}], "]"}]], "Input",
 CellChangeTimes->{
  3.609314362949*^9, {3.609314673223*^9, 3.60931467346*^9}, {
   3.609314747466*^9, 3.6093147477650003`*^9}, {3.609314793804*^9, 
   3.609314793948*^9}, {3.6093148692860003`*^9, 3.6093148695360003`*^9}, {
   3.609314965477*^9, 3.6093149657390003`*^9}, {3.609315127226*^9, 
   3.609315165483*^9}, {3.609315361033*^9, 3.6093153693199997`*^9}, {
   3.609315407317*^9, 3.6093154074309998`*^9}, {3.609315618266*^9, 
   3.609315618566*^9}, 3.6093156675109997`*^9, 3.609315737104*^9, {
   3.6094044220360003`*^9, 3.609404437336*^9}}],

Cell[BoxData[
 GraphicsBox[
  {RGBColor[0.798413061722744, 0.824719615472648, 0.968322270542458], 
   EdgeForm[Opacity[0.609]], {}, 
   {RGBColor[0.798413061722744, 0.824719615472648, 0.968322270542458], 
    EdgeForm[Opacity[0.609]], 
    TagBox[
     TooltipBox[
      TagBox[
       DynamicBox[{
         FEPrivate`If[
          CurrentValue["MouseOver"], 
          EdgeForm[{
            GrayLevel[0.5], 
            AbsoluteThickness[1.5], 
            Opacity[0.66]}], {}, {}], 
         RectangleBox[{-14., 0}, {-12., 1}, "RoundingRadius" -> 0]},
        ImageSizeCache->{{22.5, 42.564364207221345`}, {70.5716413815882, 
         71.62368260912457}}],
       StatusArea[#, 1]& ,
       TagBoxNote->"1"],
      StyleBox["1", {
        GrayLevel[0]}, StripOnInput -> False]],
     Annotation[#, 
      Style[1, {
        GrayLevel[0]}], "Tooltip"]& ], 
    TagBox[
     TooltipBox[
      TagBox[
       DynamicBox[{
         FEPrivate`If[
          CurrentValue["MouseOver"], 
          EdgeForm[{
            GrayLevel[0.5], 
            AbsoluteThickness[1.5], 
            Opacity[0.66]}], {}, {}], 
         RectangleBox[{-12., 0}, {-10., 3}, "RoundingRadius" -> 0]},
        ImageSizeCache->{{41.564364207221345`, 61.62872841444269}, {
         70.46755892651545, 71.62368260912457}}],
       StatusArea[#, 3]& ,
       TagBoxNote->"3"],
      StyleBox["3", {
        GrayLevel[0]}, StripOnInput -> False]],
     Annotation[#, 
      Style[3, {
        GrayLevel[0]}], "Tooltip"]& ], 
    TagBox[
     TooltipBox[
      TagBox[
       DynamicBox[{
         FEPrivate`If[
          CurrentValue["MouseOver"], 
          EdgeForm[{
            GrayLevel[0.5], 
            AbsoluteThickness[1.5], 
            Opacity[0.66]}], {}, {}], 
         RectangleBox[{-10., 0}, {-8., 27}, "RoundingRadius" -> 0]},
        ImageSizeCache->{{60.62872841444269, 80.69309262166405}, {
         69.21856946564245, 71.62368260912457}}],
       StatusArea[#, 27]& ,
       TagBoxNote->"27"],
      StyleBox["27", {
        GrayLevel[0]}, StripOnInput -> False]],
     Annotation[#, 
      Style[27, {
        GrayLevel[0]}], "Tooltip"]& ], 
    TagBox[
     TooltipBox[
      TagBox[
       DynamicBox[{
         FEPrivate`If[
          CurrentValue["MouseOver"], 
          EdgeForm[{
            GrayLevel[0.5], 
            AbsoluteThickness[1.5], 
            Opacity[0.66]}], {}, {}], 
         RectangleBox[{-8., 0}, {-6., 158}, "RoundingRadius" -> 0]},
        ImageSizeCache->{{79.69309262166405, 99.75745682888541}, {
         62.401168658377344`, 71.62368260912457}}],
       StatusArea[#, 158]& ,
       TagBoxNote->"158"],
      StyleBox["158", {
        GrayLevel[0]}, StripOnInput -> False]],
     Annotation[#, 
      Style[158, {
        GrayLevel[0]}], "Tooltip"]& ], 
    TagBox[
     TooltipBox[
      TagBox[
       DynamicBox[{
         FEPrivate`If[
          CurrentValue["MouseOver"], 
          EdgeForm[{
            GrayLevel[0.5], 
            AbsoluteThickness[1.5], 
            Opacity[0.66]}], {}, {}], 
         RectangleBox[{-6., 0}, {-4., 561}, "RoundingRadius" -> 0]},
        ImageSizeCache->{{98.75745682888541, 118.82182103610675`}, {
         41.42855396121828, 71.62368260912457}}],
       StatusArea[#, 561]& ,
       TagBoxNote->"561"],
      StyleBox["561", {
        GrayLevel[0]}, StripOnInput -> False]],
     Annotation[#, 
      Style[561, {
        GrayLevel[0]}], "Tooltip"]& ], 
    TagBox[
     TooltipBox[
      TagBox[
       DynamicBox[{
         FEPrivate`If[
          CurrentValue["MouseOver"], 
          EdgeForm[{
            GrayLevel[0.5], 
            AbsoluteThickness[1.5], 
            Opacity[0.66]}], {}, {}], 
         RectangleBox[{-4., 0}, {-2., 1561}, "RoundingRadius" -> 0]},
        ImageSizeCache->{{117.82182103610675`, 
         137.8861852433281}, {-10.612673575156577`, 71.62368260912457}}],
       StatusArea[#, 1561]& ,
       TagBoxNote->"1561"],
      StyleBox["1561", {
        GrayLevel[0]}, StripOnInput -> False]],
     Annotation[#, 
      Style[1561, {
        GrayLevel[0]}], "Tooltip"]& ], 
    TagBox[
     TooltipBox[
      TagBox[
       DynamicBox[{
         FEPrivate`If[
          CurrentValue["MouseOver"], 
          EdgeForm[{
            GrayLevel[0.5], 
            AbsoluteThickness[1.5], 
            Opacity[0.66]}], {}, {}], 
         RectangleBox[{-2., 0}, {0., 2637}, "RoundingRadius" -> 0]},
        ImageSizeCache->{{136.8861852433281, 
         156.95054945054946`}, {-66.60903440429591, 71.62368260912457}}],
       StatusArea[#, 2637]& ,
       TagBoxNote->"2637"],
      StyleBox["2637", {
        GrayLevel[0]}, StripOnInput -> False]],
     Annotation[#, 
      Style[2637, {
        GrayLevel[0]}], "Tooltip"]& ], 
    TagBox[
     TooltipBox[
      TagBox[
       DynamicBox[{
         FEPrivate`If[
          CurrentValue["MouseOver"], 
          EdgeForm[{
            GrayLevel[0.5], 
            AbsoluteThickness[1.5], 
            Opacity[0.66]}], {}, {}], 
         RectangleBox[{0., 0}, {2., 2698}, "RoundingRadius" -> 0]},
        ImageSizeCache->{{155.95054945054946`, 
         176.01491365777082`}, {-69.7835492840148, 71.62368260912457}}],
       StatusArea[#, 2698]& ,
       TagBoxNote->"2698"],
      StyleBox["2698", {
        GrayLevel[0]}, StripOnInput -> False]],
     Annotation[#, 
      Style[2698, {
        GrayLevel[0]}], "Tooltip"]& ], 
    TagBox[
     TooltipBox[
      TagBox[
       DynamicBox[{
         FEPrivate`If[
          CurrentValue["MouseOver"], 
          EdgeForm[{
            GrayLevel[0.5], 
            AbsoluteThickness[1.5], 
            Opacity[0.66]}], {}, {}], 
         RectangleBox[{2., 0}, {4., 1600}, "RoundingRadius" -> 0]},
        ImageSizeCache->{{175.01491365777082`, 
         195.07927786499215`}, {-12.642281449075199`, 71.62368260912457}}],
       StatusArea[#, 1600]& ,
       TagBoxNote->"1600"],
      StyleBox["1600", {
        GrayLevel[0]}, StripOnInput -> False]],
     Annotation[#, 
      Style[1600, {
        GrayLevel[0]}], "Tooltip"]& ], 
    TagBox[
     TooltipBox[
      TagBox[
       DynamicBox[{
         FEPrivate`If[
          CurrentValue["MouseOver"], 
          EdgeForm[{
            GrayLevel[0.5], 
            AbsoluteThickness[1.5], 
            Opacity[0.66]}], {}, {}], 
         RectangleBox[{4., 0}, {6., 598}, "RoundingRadius" -> 0]},
        ImageSizeCache->{{194.07927786499215`, 214.1436420722135}, {
         39.503028542372405`, 71.62368260912457}}],
       StatusArea[#, 598]& ,
       TagBoxNote->"598"],
      StyleBox["598", {
        GrayLevel[0]}, StripOnInput -> False]],
     Annotation[#, 
      Style[598, {
        GrayLevel[0]}], "Tooltip"]& ], 
    TagBox[
     TooltipBox[
      TagBox[
       DynamicBox[{
         FEPrivate`If[
          CurrentValue["MouseOver"], 
          EdgeForm[{
            GrayLevel[0.5], 
            AbsoluteThickness[1.5], 
            Opacity[0.66]}], {}, {}], 
         RectangleBox[{6., 0}, {8., 140}, "RoundingRadius" -> 0]},
        ImageSizeCache->{{213.1436420722135, 233.20800627943487`}, {
         63.337910754032094`, 71.62368260912457}}],
       StatusArea[#, 140]& ,
       TagBoxNote->"140"],
      StyleBox["140", {
        GrayLevel[0]}, StripOnInput -> False]],
     Annotation[#, 
      Style[140, {
        GrayLevel[0]}], "Tooltip"]& ], 
    TagBox[
     TooltipBox[
      TagBox[
       DynamicBox[{
         FEPrivate`If[
          CurrentValue["MouseOver"], 
          EdgeForm[{
            GrayLevel[0.5], 
            AbsoluteThickness[1.5], 
            Opacity[0.66]}], {}, {}], 
         RectangleBox[{8., 0}, {10., 15}, "RoundingRadius" -> 0]},
        ImageSizeCache->{{232.20800627943487`, 252.27237048665623`}, {
         69.84306419607896, 71.62368260912457}}],
       StatusArea[#, 15]& ,
       TagBoxNote->"15"],
      StyleBox["15", {
        GrayLevel[0]}, StripOnInput -> False]],
     Annotation[#, 
      Style[15, {
        GrayLevel[0]}], "Tooltip"]& ], 
    TagBox[
     TooltipBox[
      TagBox[
       DynamicBox[{
         FEPrivate`If[
          CurrentValue["MouseOver"], 
          EdgeForm[{
            GrayLevel[0.5], 
            AbsoluteThickness[1.5], 
            Opacity[0.66]}], {}, {}], 
         RectangleBox[{10., 0}, {12., 1}, "RoundingRadius" -> 0]},
        ImageSizeCache->{{251.27237048665623`, 271.3367346938776}, {
         70.5716413815882, 71.62368260912457}}],
       StatusArea[#, 1]& ,
       TagBoxNote->"1"],
      StyleBox["1", {
        GrayLevel[0]}, StripOnInput -> False]],
     Annotation[#, 
      Style[1, {
        GrayLevel[0]}], "Tooltip"]& ]}, {}, {}},
  AspectRatio->NCache[GoldenRatio^(-1), 0.6180339887498948],
  Axes->{True, True},
  AxesLabel->{
    FormBox["\"Exp. PL/Trade ($)\"", TraditionalForm], None},
  AxesOrigin->{-14., 0},
  FrameTicks->{{Automatic, Automatic}, {Automatic, Automatic}},
  GridLines->{None, None},
  PlotRange->{{-14., 12.}, {All, All}},
  PlotRangePadding->{{
     Scaled[0.02], 
     Scaled[0.02]}, {
     Scaled[0.02], 
     Scaled[0.1]}},
  Ticks->{Automatic, Automatic}]], "Output",
 CellChangeTimes->{
  3.609314378242*^9, 3.6093146902060003`*^9, 3.609314769776*^9, 
   3.609314809484*^9, 3.609314932278*^9, 3.6093149985290003`*^9, {
   3.609315158528*^9, 3.609315182258*^9}, 3.609315386449*^9, 
   3.609315438639*^9, 3.6093156420290003`*^9, 3.609315700184*^9, 
   3.609315771031*^9, 3.609404456325*^9}]
}, Open  ]]
}, Open  ]]
}, Open  ]],

Cell[CellGroupData[{

Cell["Conclusions", "Subtitle",
 CellChangeTimes->{{3.609475444017*^9, 3.609475479124*^9}}],

Cell["\<\
The key conclusions from this analysis are : \
\>", "Text",
 CellChangeTimes->{{3.609475305884*^9, 3.6094754137*^9}}],

Cell[CellGroupData[{

Cell[TextData[{
 "Sc",
 StyleBox["alping is essentially a volatility trade", "SubitemNumbered"]
}], "ItemNumbered",
 CellChangeTimes->{{3.609475305884*^9, 3.6094754319*^9}}],

Cell[TextData[StyleBox["The setting of optimal profit targets are stop loss \
limits depend critically on the volatility of the underlying, and needs to be \
handled dynamically, \t\t     depending on current levels of market \
volatility", "SubitemNumbered"]], "ItemNumbered",
 CellChangeTimes->{{3.609475305884*^9, 3.609475436137*^9}}],

Cell[TextData[StyleBox["At low levels of volatility we should set tight \
profit targets and wide stop loss limits, looking to make a high percentage \
of small gains, of perhaps 2 - 3           ticks.", "SubitemNumbered"]], \
"ItemNumbered",
 CellChangeTimes->{{3.609475305884*^9, 3.6094754400620003`*^9}}],

Cell[TextData[{
 StyleBox[" As volatility ", "SubitemNumbered"],
 "rises, we need to reverse that position, setting more ambitious profit \
targets and tight stops, aiming for the occasional big win."
}], "ItemNumbered",
 CellChangeTimes->{{3.609475305884*^9, 3.60947544006*^9}}]
}, Open  ]]
}, Open  ]]
}, Open  ]]
},
WindowSize->{1121, 1025},
WindowMargins->{{32, Automatic}, {17, Automatic}},
FrontEndVersion->"9.0 for Microsoft Windows (64-bit) (January 25, 2013)",
StyleDefinitions->"Default.nb"
]
(* End of Notebook Content *)

(* Internal cache information *)
(*CellTagsOutline
CellTagsIndex->{}
*)
(*CellTagsIndex
CellTagsIndex->{}
*)
(*NotebookFileOutline
Notebook[{
Cell[CellGroupData[{
Cell[1485, 35, 123, 1, 101, "Title"],
Cell[1611, 38, 3730, 62, 600, "Text"],
Cell[CellGroupData[{
Cell[5366, 104, 107, 1, 56, "Subtitle"],
Cell[5476, 107, 1274, 18, 144, "Text"]
}, Open  ]],
Cell[CellGroupData[{
Cell[6787, 130, 114, 1, 56, "Subtitle"],
Cell[6904, 133, 908, 17, 201, "Text"],
Cell[CellGroupData[{
Cell[7837, 154, 1495, 43, 172, "Input"],
Cell[9335, 199, 13113, 227, 250, "Output"]
}, Open  ]],
Cell[22463, 429, 1945, 44, 562, "Text"]
}, Open  ]],
Cell[CellGroupData[{
Cell[24445, 478, 108, 1, 56, "Subtitle"],
Cell[24556, 481, 1545, 23, 220, "Text"],
Cell[26104, 506, 3081, 68, 352, "Input"],
Cell[29188, 576, 405, 7, 68, "Text"],
Cell[CellGroupData[{
Cell[29618, 587, 410, 7, 31, "Input"],
Cell[30031, 596, 383, 8, 31, "Output"]
}, Open  ]]
}, Open  ]],
Cell[CellGroupData[{
Cell[30463, 610, 102, 1, 56, "Subtitle"],
Cell[30568, 613, 372, 7, 49, "Text"],
Cell[CellGroupData[{
Cell[30965, 624, 3135, 63, 112, "Input"],
Cell[34103, 689, 4860, 96, 566, "Output"]
}, Open  ]],
Cell[CellGroupData[{
Cell[39000, 790, 2043, 47, 112, "Input"],
Cell[41046, 839, 4626, 92, 544, "Output"]
}, Open  ]],
Cell[45687, 934, 1699, 25, 239, "Text"]
}, Open  ]],
Cell[CellGroupData[{
Cell[47423, 964, 100, 1, 56, "Subtitle"],
Cell[47526, 967, 615, 12, 87, "Text"],
Cell[48144, 981, 239, 5, 31, "Input"],
Cell[48386, 988, 393, 12, 96, "Input"],
Cell[CellGroupData[{
Cell[48804, 1004, 638, 20, 31, "Input",
 CellID->230444506],
Cell[49445, 1026, 46197, 771, 248, "Output"]
}, Open  ]],
Cell[CellGroupData[{
Cell[95679, 1802, 160, 4, 31, "Input",
 CellID->1988],
Cell[95842, 1808, 222, 6, 31, "Output"]
}, Open  ]],
Cell[CellGroupData[{
Cell[96101, 1819, 165, 4, 31, "Input",
 CellID->16798],
Cell[96269, 1825, 257, 8, 49, "Output"]
}, Open  ]],
Cell[96541, 1836, 295, 5, 49, "Text"],
Cell[96839, 1843, 353, 10, 51, "Text"],
Cell[97195, 1855, 159, 3, 30, "Text"],
Cell[97357, 1860, 3238, 73, 352, "Input"],
Cell[CellGroupData[{
Cell[100620, 1937, 286, 7, 31, "Input"],
Cell[100909, 1946, 105, 1, 31, "Output"]
}, Open  ]],
Cell[101029, 1950, 249, 5, 30, "Text"],
Cell[CellGroupData[{
Cell[101303, 1959, 3142, 63, 112, "Input"],
Cell[104448, 2024, 4876, 97, 566, "Output"]
}, Open  ]],
Cell[CellGroupData[{
Cell[109361, 2126, 2095, 47, 112, "Input"],
Cell[111459, 2175, 4871, 97, 544, "Output"]
}, Open  ]],
Cell[116345, 2275, 231, 4, 30, "Text"],
Cell[CellGroupData[{
Cell[116601, 2283, 2961, 73, 152, "Input"],
Cell[119565, 2358, 7817, 154, 518, "Output"]
}, Open  ]],
Cell[127397, 2515, 2350, 36, 334, "Text"]
}, Open  ]],
Cell[CellGroupData[{
Cell[129784, 2556, 147, 2, 56, "Subtitle"],
Cell[129934, 2560, 468, 8, 49, "Text"],
Cell[CellGroupData[{
Cell[130427, 2572, 102, 1, 33, "Subsubtitle"],
Cell[130532, 2575, 3651, 81, 332, "Input"],
Cell[CellGroupData[{
Cell[134208, 2660, 239, 4, 31, "Input"],
Cell[134450, 2666, 305, 7, 31, "Output"]
}, Open  ]],
Cell[134770, 2676, 386, 6, 49, "Text"],
Cell[CellGroupData[{
Cell[135181, 2686, 1077, 22, 31, "Input"],
Cell[136261, 2710, 8231, 246, 186, "Output"]
}, Open  ]],
Cell[CellGroupData[{
Cell[144529, 2961, 633, 16, 31, "Input"],
Cell[145165, 2979, 9799, 300, 187, "Output"]
}, Open  ]]
}, Open  ]],
Cell[CellGroupData[{
Cell[155013, 3285, 122, 3, 33, "Subsubtitle"],
Cell[155138, 3290, 171, 4, 30, "Text"],
Cell[155312, 3296, 3488, 83, 392, "Input"],
Cell[CellGroupData[{
Cell[158825, 3383, 1582, 30, 52, "Input"],
Cell[160410, 3415, 6147, 184, 186, "Output"]
}, Open  ]],
Cell[CellGroupData[{
Cell[166594, 3604, 1084, 23, 52, "Input"],
Cell[167681, 3629, 9392, 285, 193, "Output"]
}, Open  ]]
}, Open  ]]
}, Open  ]],
Cell[CellGroupData[{
Cell[177134, 3921, 91, 1, 56, "Subtitle"],
Cell[177228, 3924, 127, 3, 30, "Text"],
Cell[CellGroupData[{
Cell[177380, 3931, 173, 4, 30, "ItemNumbered"],
Cell[177556, 3937, 337, 4, 45, "ItemNumbered"],
Cell[177896, 3943, 307, 4, 45, "ItemNumbered"],
Cell[178206, 3949, 279, 5, 30, "ItemNumbered"]
}, Open  ]]
}, Open  ]]
}, Open  ]]
}
]
*)

(* End of internal cache information *)

(* NotebookSignature Mupy5h84Zk@aVAK3ElXuCmDm *)
