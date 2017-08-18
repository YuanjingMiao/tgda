#define _GNU_SOURCE
#import <assert.h>
#import <fenv.h>
#import <stdio.h>
#import <time.h>
#import <Foundation/Foundation.h>
#import <Foundation/NSString.h>
#import "fftw3.h"
#import "Core/Basics/NpBasics.h"
#import "Core/Math/NpMath.h"
#import "Core/Timer/NPTimer.h"
#import "ODConstants.h"
#import "ODEnergy.h"
#import "ODGaussianRNG.h"

typedef struct SpectrumGeometry
{
    int geometryResolution;
    int gradientResolution;
    int numberOfLods;
    double * sizes;
}
SpectrumGeometry;

typedef enum SpectrumGenerator
{
    Unknown  = -1,
    PiersonMoskowitz = 0,
    JONSWAP = 1,
    Donelan = 2,
    Unified  = 3
}
SpectrumGenerator;

enum
{
    GeneratorOptionsHeights      = (1 << 0),
    GeneratorOptionsDisplacement = (1 << 1),
    GeneratorOptionsGradient     = (1 << 2),
    GeneratorOptionsDisplacementDerivatives = (1 << 3)
};

typedef NSUInteger GeneratorOptions;

typedef struct SpectrumParameters
{
    double U10;
    double fetch;
}
SpectrumParameters;

typedef struct GeneratorSettings
{
    SpectrumGenerator  generatorType;
    SpectrumParameters parameters;
    GeneratorOptions   options;
}
GeneratorSettings;

static void generatePM(
	const SpectrumGeometry * const geometry,
	const SpectrumParameters * const settings,
	const double * const randomNumbers,
	fftwf_complex * const H0
	)
{
    const int resolution  = MAX(geometry->geometryResolution, geometry->gradientResolution);
    const float fresolution = (float)resolution;

    const int numberOfLods = geometry->numberOfLods;
    const int numberOfLodElements = resolution * resolution;

    const float U10   = settings->U10;

    const float n = -(fresolution / 2.0f);
    const float m =  (fresolution / 2.0f);

    const float omega_p = peak_energy_wave_frequency_pm(U10);

    for ( int l = 0; l < numberOfLods; l++ )
    {
        const float lastSize = ( l == 0 ) ? 0.0f : geometry->sizes[l - 1];
        const float currentSize = geometry->sizes[l];

        const float dkx = MATH_2_MUL_PIf / currentSize;
        const float dky = MATH_2_MUL_PIf / currentSize;

        const float kMinX = ( l == 0 ) ? 0.0f : (( MATH_PI * fresolution ) / lastSize );
        const float kMinY = ( l == 0 ) ? 0.0f : (( MATH_PI * fresolution ) / lastSize );
        const float kMin = sqrtf(kMinX*kMinX + kMinY*kMinY);

        const int offset = l * numberOfLodElements;

        for ( int i = 0; i < resolution; i++ )
        {
            for ( int j = 0; j < resolution; j++ )
            {
                const int index = offset + j + resolution * i;

                const float xi_r = (float)randomNumbers[2 * index    ];
                const float xi_i = (float)randomNumbers[2 * index + 1];

                const float di = i;
                const float dj = j;

                // wave vector
                const float kx = (n + dj) * dkx;
                const float ky = (m - di) * dky;

                // wave number
                const float k = sqrtf(kx*kx + ky*ky);

                // deep water dispersion relation
                const float omega = sqrtf(k * EARTH_ACCELERATIONf);

                // Theta in wave vector domain
                float Theta_complete = 0.0f;

                if (k > kMin)
                {
                    // Theta in wave frequency domain
                    const float Theta = energy_pm_wave_frequency(omega, U10);
                    // convert Theta to wave number domain
                    const float Theta_wavenumber = Theta * 0.5f * (EARTH_ACCELERATIONf / omega);
                    // convert Theta to wave vector domain
                    const float Theta_wavevector = Theta_wavenumber / k;

                    const float directionalSpread
                        = directional_spreading_mitsuyasu_hasselmann(omega_p, omega, 0.0f, atan2f(ky, kx));

                    Theta_complete = Theta_wavevector * directionalSpread;
                }

                const float amplitude = sqrtf(2.0f * Theta_complete * dkx * dky);
                H0[index][0] = MATH_1_DIV_SQRT_2f * xi_r * amplitude * 0.5f;
                H0[index][1] = MATH_1_DIV_SQRT_2f * xi_i * amplitude * 0.5f;
            }
        }
    }	
}

static void generateJONSWAP(
	const SpectrumGeometry * const geometry,
	const SpectrumParameters * const settings,
	const double * const randomNumbers,
	fftwf_complex * const H0
	)
{
    const int resolution  = MAX(geometry->geometryResolution, geometry->gradientResolution);
    const float fresolution = (float)resolution;

    const int numberOfLods = geometry->numberOfLods;
    const int numberOfLodElements = resolution * resolution;

    const float U10   = settings->U10;
    const float fetch = settings->fetch;

    const float n = -(fresolution / 2.0f);
    const float m =  (fresolution / 2.0f);

    const float omega_p = peak_energy_wave_frequency_jonswap(U10, fetch);

    for ( int l = 0; l < numberOfLods; l++ )
    {
        const float lastSize = ( l == 0 ) ? 0.0f : geometry->sizes[l - 1];
        const float currentSize = geometry->sizes[l];

        const float dkx = MATH_2_MUL_PIf / currentSize;
        const float dky = MATH_2_MUL_PIf / currentSize;

        const float kMinX = ( l == 0 ) ? 0.0f : (( MATH_PI * fresolution ) / lastSize );
        const float kMinY = ( l == 0 ) ? 0.0f : (( MATH_PI * fresolution ) / lastSize );
        const float kMin = sqrtf(kMinX*kMinX + kMinY*kMinY);

        const int offset = l * numberOfLodElements;

        for ( int i = 0; i < resolution; i++ )
        {
            for ( int j = 0; j < resolution; j++ )
            {
                const int index = offset + j + resolution * i;

                const float xi_r = (float)randomNumbers[2 * index    ];
                const float xi_i = (float)randomNumbers[2 * index + 1];

                const float di = i;
                const float dj = j;

                // wave vector
                const float kx = (n + dj) * dkx;
                const float ky = (m - di) * dky;

                // wave number
                const float k = sqrtf(kx*kx + ky*ky);

                // deep water dispersion relation
                const float omega = sqrtf(k * EARTH_ACCELERATIONf);

                // Theta in wave vector domain
                float Theta_complete = 0.0f;

                if (k > kMin)
                {
                    // Theta in wave frequency domain
                    const float Theta = energy_jonswap_wave_frequency(omega, U10, fetch);
                    // convert Theta to wave number domain
                    const float Theta_wavenumber = Theta * 0.5f * (EARTH_ACCELERATIONf / omega);
                    // convert Theta to wave vector domain
                    const float Theta_wavevector = Theta_wavenumber / k;

                    const float directionalSpread
                        = directional_spreading_mitsuyasu_hasselmann(omega_p, omega, 0.0f, atan2f(ky, kx));

                    Theta_complete = Theta_wavevector * directionalSpread;
                }

                const float amplitude = sqrtf(2.0f * Theta_complete * dkx * dky);
                H0[index][0] = MATH_1_DIV_SQRT_2f * xi_r * amplitude * 0.5f;
                H0[index][1] = MATH_1_DIV_SQRT_2f * xi_i * amplitude * 0.5f;
            }
        }
    }	
}

static void generateDonelan(
	const SpectrumGeometry * const geometry,
	const SpectrumParameters * const settings,
	const double * const randomNumbers,
	fftwf_complex * const H0
	)
{
    const int resolution  = MAX(geometry->geometryResolution, geometry->gradientResolution);
    const float fresolution = (float)resolution;

    const int numberOfLods = geometry->numberOfLods;
    const int numberOfLodElements = resolution * resolution;

    const float U10   = settings->U10;
    const float fetch = settings->fetch;

    const float n = -(fresolution / 2.0f);
    const float m =  (fresolution / 2.0f);

    const float omega_p = peak_energy_wave_frequency_donelan(U10, fetch);

    for ( int l = 0; l < numberOfLods; l++ )
    {
        const float lastSize = ( l == 0 ) ? 0.0f : geometry->sizes[l - 1];
        const float currentSize = geometry->sizes[l];

        const float dkx = MATH_2_MUL_PIf / currentSize;
        const float dky = MATH_2_MUL_PIf / currentSize;

        const float kMinX = ( l == 0 ) ? 0.0f : (( MATH_PI * fresolution ) / lastSize );
        const float kMinY = ( l == 0 ) ? 0.0f : (( MATH_PI * fresolution ) / lastSize );
        const float kMin = sqrtf(kMinX*kMinX + kMinY*kMinY);

        const int offset = l * numberOfLodElements;

        for ( int i = 0; i < resolution; i++ )
        {
            for ( int j = 0; j < resolution; j++ )
            {
                const int index = offset + j + resolution * i;

                const float xi_r = (float)randomNumbers[2 * index    ];
                const float xi_i = (float)randomNumbers[2 * index + 1];

                const float di = i;
                const float dj = j;

                // wave vector
                const float kx = (n + dj) * dkx;
                const float ky = (m - di) * dky;

                // wave number
                const float k = sqrtf(kx*kx + ky*ky);

                // deep water dispersion relation
                const float omega = sqrtf(k * EARTH_ACCELERATIONf);

                // Theta in wave vector domain
                float Theta_complete = 0.0f;

                if (k > kMin)
                {
                    // Theta in wave frequency domain
                    const float Theta = energy_donelan_wave_frequency(omega, U10, fetch);
                    // convert Theta from wave frequency domain to wave number domain
                    const float Theta_wavenumber = Theta * 0.5f * (EARTH_ACCELERATIONf / omega);
                    // convert Theta from wave number domain to wave vector domain
                    const float Theta_wavevector = Theta_wavenumber / k;

                    const float directionalSpread
                        = directional_spreading_mitsuyasu_hasselmann(omega_p, omega, 0.0f, atan2f(ky, kx));

                    Theta_complete = Theta_wavevector * directionalSpread;
                }

                const float amplitude = sqrtf(2.0f * Theta_complete * dkx * dky);
                H0[index][0] = MATH_1_DIV_SQRT_2f * xi_r * amplitude * 0.5f;
                H0[index][1] = MATH_1_DIV_SQRT_2f * xi_i * amplitude * 0.5f;
            }
        }
    }	
}

static void generateUnified(
	const SpectrumGeometry * const geometry,
	const SpectrumParameters * const settings,
	const double * const randomNumbers,
	fftwf_complex * const H0
	)
{
    const int resolution  = MAX(geometry->geometryResolution, geometry->gradientResolution);
    const float fresolution = (float)resolution;

    const int numberOfLods = geometry->numberOfLods;
    const int numberOfLodElements = resolution * resolution;

    const float U10   = settings->U10;
    const float fetch = settings->fetch;

    const float n = -(fresolution / 2.0f);
    const float m =  (fresolution / 2.0f);

	const float k_p = peak_energy_wave_number_unified(U10, fetch);

    for ( int l = 0; l < numberOfLods; l++ )
    {
        const float lastSize = ( l == 0 ) ? 0.0f : geometry->sizes[l - 1];
        const float currentSize = geometry->sizes[l];

        const float dkx = MATH_2_MUL_PIf / currentSize;
        const float dky = MATH_2_MUL_PIf / currentSize;

        const float kMinX = ( l == 0 ) ? 0.0f : (( MATH_PI * fresolution ) / lastSize );
        const float kMinY = ( l == 0 ) ? 0.0f : (( MATH_PI * fresolution ) / lastSize );
        const float kMin = sqrtf(kMinX*kMinX + kMinY*kMinY);

        const int offset = l * numberOfLodElements;

        for ( int i = 0; i < resolution; i++ )
        {
            for ( int j = 0; j < resolution; j++ )
            {
                const int index = offset + j + resolution * i;

                const float xi_r = (float)randomNumbers[2 * index    ];
                const float xi_i = (float)randomNumbers[2 * index + 1];

                const float di = i;
                const float dj = j;

                // wave vector
                const float kx = (n + dj) * dkx;
                const float ky = (m - di) * dky;

                // wave number
                const float k = sqrtf(kx*kx + ky*ky);

                // Theta in wave vector domain
                float Theta_complete = 0.0f;

                if (k > kMin)
                {
                    const float Theta_wavenumber = energy_unified_wave_number(k, U10, fetch);
                    const float Theta_wavevector = Theta_wavenumber / k;

                    const float directionalSpread
                        = directional_spreading_unified(U10, k_p, k, 0.0f, atan2f(ky, kx));

                    Theta_complete = Theta_wavevector * directionalSpread;
                }

                const float amplitude = sqrtf(2.0f * Theta_complete * dkx * dky);
                H0[index][0] = MATH_1_DIV_SQRT_2f * xi_r * amplitude * 0.5f;
                H0[index][1] = MATH_1_DIV_SQRT_2f * xi_i * amplitude * 0.5f;
            }
        }
    }	
}

static void print_complex_spectrum(int resolution, fftwf_complex * spectrum)
{
    printf("Complex spectrum\n");
    for ( int j = 0; j < resolution; j++ )
    {
        for ( int k = 0; k < resolution; k++ )
        {
            printf("%+f %+fi ", spectrum[j * resolution + k][0], spectrum[j * resolution + k][1]);
        }

        printf("\n");
    }

    printf("\n");
}

static const int resolutions[] = {8, 16, 32, 64, 128, 256, 512, 1024};

int main (int argc, char **argv)
{
	NSAutoreleasePool * pool = [ NSAutoreleasePool new ];

	NPTimer * timer = [[ NPTimer alloc ] init ];
	OdGaussianRng * gaussianRNG = odgaussianrng_alloc_init();

	double maxSize = 100; // metre

	SpectrumGeometry geometry;
	geometry.numberOfLods = 1;
	geometry.geometryResolution = 512;
	geometry.gradientResolution = 512;
	geometry.sizes = malloc(sizeof(double)*geometry.numberOfLods);
	geometry.sizes[0] = maxSize;

	const double goldenRatio = (1.0 + sqrt(5.0)) / 2.0;
	const double goldenRatioLong = 1.0 / goldenRatio;
	const double goldenRatioShort = 1.0 - (1.0 / goldenRatio);

	for ( int i = 1; i < geometry.numberOfLods; i++ )
	{
		const double s = geometry.sizes[i-1];
		geometry.sizes[i] = s * goldenRatioShort;
	}

    int necessaryResolution = MAX(geometry.geometryResolution, geometry.gradientResolution);
    const size_t n
        = necessaryResolution * necessaryResolution * geometry.numberOfLods;

    GeneratorSettings settings;
    settings.generatorType = Unified;
    settings.parameters.U10 = 10.0;
    settings.parameters.fetch = 500000.0;

    double accumulatedTime = 0.0;
    const int nIterations = 100;
    for ( int i = 0; i < nIterations; i++)
    {
		[ timer update ];
	    fftwf_complex * H0 = fftwf_alloc_complex(n);
	    double * randomNumbers = malloc(sizeof(double) * 2 * n);
	    odgaussianrng_get_array(gaussianRNG, randomNumbers, 2 * geometry.numberOfLods * necessaryResolution * necessaryResolution);
	    generateUnified(&geometry, &(settings.parameters), randomNumbers, H0);
	    free(randomNumbers);
    	fftwf_free(H0);	    
		[ timer update ];
		accumulatedTime += [timer frameTime];
	}
	NSLog(@"%f sec", accumulatedTime / (double)nIterations);

    //print_complex_spectrum(necessaryResolution, H0);



    odgaussianrng_free(gaussianRNG);
    DESTROY(timer);
    DESTROY(pool);

    return EXIT_SUCCESS;
}