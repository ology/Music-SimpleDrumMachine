# Music-SimpleDrumMachine
Simple 16th-note Phrase Drummer

Test with these:

```shell
perl -Ilib -MMusic::SimpleDrumMachine -E'$dm = Music::SimpleDrumMachine->new(verbose => 1, port_name => shift)' fluid

perl -Ilib eg/add-drums.pl fluid 90

perl -Ilib eg/euclidean.pl fluid 90
```