#!/bin/bash

KERNEL_DIR=$PWD
KERNEL_DEFCONFIG=potter_defconfig
DTBTOOL=$KERNEL_DIR/Dtbtool/
ANY_KERNEL2_DIR=/datadrive/android/repos/noob/AnyKernel2
FINAL_KERNEL_ZIP=NoobKernel.zip
CCACHE=$(command -v ccache)
export ARCH="arm64"
export CROSS_COMPILE="aarch64-linux-gnu-"
export TOOL_CHAIN_PATH="/datadrive/android/repos/noob/tc/bin"
export CLANG_TCHAIN="/datadrive/android/repos/noob/clang/clang-4579689/bin/clang"
export LD_LIBRARY_PATH="${TOOL_CHAIN_PATH}/../lib"
export PATH=$PATH:${TOOL_CHAIN_PATH}

kmake() {
	        make CC="${CCACHE} ${CLANG_TCHAIN}" \
			             CLANG_TRIPLE=aarch64-linux-gnu- \
				                  CROSS_COMPILE=${TOOL_CHAIN_PATH}/${CROSS_COMPILE} \
						               HOSTCC="${CLANG_TCHAIN}" \
							                    $@
	}

	clean () {
		        kmake clean && kmake mrproper
		}

		compile() {
			        kmake $KERNEL_DEFCONFIG
				        kmake -j16
				}

				DTB () {
					        $DTBTOOL/dtbToolCM -2 -o $KERNEL_DIR/arch/arm/boot/dtb -s 2048 -p $KERNEL_DIR/scripts/dtc/ $KERNEL_DIR/arch/arm/boot/dts/qcom/
					}

					AnyKernel () {
						        ls $ANY_KERNEL2_DIR
							        rm -rf $ANY_KERNEL2_DIR/dtb
								        rm -rf $ANY_KERNEL2_DIR/Image.gz
									        rm -rf $ANY_KERNEL2_DIR/$FINAL_KERNEL_ZIP
										        cp $KERNEL_DIR/arch/arm64/boot/Image.gz $ANY_KERNEL2_DIR/
											        cp $KERNEL_DIR/arch/arm/boot/dtb $ANY_KERNEL2_DIR/
												        cd $ANY_KERNEL2_DIR/
													        zip -r9 $FINAL_KERNEL_ZIP * -x README $FINAL_KERNEL_ZIP
														        rm -rf /datadrive/android/share/noob/$FINAL_KERNEL_ZIP
															        cp /datadrive/android/repos/noob/AnyKernel2/$FINAL_KERNEL_ZIP /datadrive/android/share/noob/$FINAL_KERNEL_ZIP
															}

															GoodBye () {
																        cd $KERNEL_DIR
																	        rm -rf arch/arm/boot/dtb
																		        rm -rf $ANY_KERNEL2_DIR/$FINAL_KERNEL_ZIP
																			        rm -rf AnyKernel2/Image.gz
																				        rm -rf AnyKernel2/dtb
																				}
																				clean
																				compile
																				DTB
																				AnyKernel
																				GoodBye
