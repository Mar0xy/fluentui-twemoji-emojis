package main

import (
	"flag"
	"image"
	"image/png"
	"log"
	"os"

	"github.com/srwiley/oksvg"
	"github.com/srwiley/rasterx"
)

func main() {
	w := flag.Int("width", 256, "output width")
	h := flag.Int("height", 256, "output height")
	flag.Parse()

	img := image.NewNRGBA(image.Rect(0, 0, *w, *h))
	icon, err := oksvg.ReadIconStream(os.Stdin)
	if err != nil {
		log.Fatal(err)
	}
	icon.SetTarget(0, 0, float64(*w), float64(*h))
	icon.Draw(rasterx.NewDasher(*w, *h, rasterx.NewScannerGV(*w, *h, img, img.Bounds())), 1)

	if err := png.Encode(os.Stdout, img); err != nil {
		log.Fatal(err)
	}
}
