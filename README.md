# senate-covid

This repo is a very basic simulation and visualization of what might happen
now that the US Senate is back in session and could suffer losses due to
COVID-19.

## Background

The US Senate has returned to work and is in session.  Given the age
demographics of the senators, should an outbreak occur, it is likely
that a number of senators would die.  This could have a profound impact
on control of the Senate, since the governor of the state would select
a replacement (until a special election can be held).

## Components

I used Wikipedia to create a CSV file of the sitting senators including
their age, party, and the party of that state's governor. I then wrote a
Perl script that takes the probabilities of a senator dying based on their
party (to reflect the differences in precautions that the various parties
are likely to take) and an age cutoff, whereby we assume that all senators
up to that age are not going to die (but might still be infected), and that
all senators above that age will be infected and will die based on the
specified probability. Obviously this is highly simplified as it ignores
existing comorbities of each senator and uses only one probability for
dying.

The script generates a CSV file consisting of the two probabilities (I
am assuming the probabilities for the two Independent senators are the
same as for Democratic senators), the average number of GOP senators
that would be in the senate, and that same number rounded.

I then used a Jupyter notebook to assist with visualizing the resulting
Senate. I'm still working on getting it to look the way I want it to.
