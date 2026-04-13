const fs = require('fs');
const path = '/home/mig/Code/healthmate/healthmate-be/src/modules/user-medication/user-medication.service.ts';
let code = fs.readFileSync(path, 'utf8');

// Replace scanAndSave
code = code.replace(
  /async scanAndSave\([\s\S]*?return ResponseHelper\.success\([\s\S]*?\);\n  \}/m,
  `async scan(scanDto: ScanMedicationDto, userId: string) {
    const { scannedText, shape, rawScannedData } = scanDto;

    // Remove noise (you can add better OCR text cleaning logic here)
    const cleanText = scannedText.trim().replace(/\\n/g, ' ');

    // 1. Try to find existing medications matched by name or genericName
    // Split text to keywords for basic full-text search capability
    const keywords = cleanText.split(' ').filter((w) => w.length > 2);

    let foundMedications: Medication[] = [];

    if (keywords.length > 0) {
      // Find combinations
      foundMedications = await this.prisma.medication.findMany({
        where: {
          OR: [
            ...keywords.map((kw) => ({
              name: { contains: kw, mode: 'insensitive' as Prisma.QueryMode },
            })),
            ...keywords.map((kw) => ({
              genericName: { contains: kw, mode: 'insensitive' as Prisma.QueryMode },
            })),
          ],
        },
        take: 5,
      });
    }

    if (foundMedications.length === 0) {
      // 2. If NO match found, create a new "unverified" Medication
      // So that the user still has something to attach to.
      const newMed = await this.prisma.medication.create({
        data: {
          name: cleanText.substring(0, 255), // limit length
          form: shape ? shape.substring(0, 20) : null,
          isVerified: false,
          createdBy: userId,
        },
      });
      foundMedications = [newMed];
    }

    return ResponseHelper.success(
      foundMedications,
      MessageCodes.MEDICATION_SEARCH_SUCCESS,
      'Medication scanned successfully'
    );
  }`
);

fs.writeFileSync(path, code);

// Now update the controller
const controllerPath = '/home/mig/Code/healthmate/healthmate-be/src/modules/user-medication/user-medication.controller.ts';
let controllerCode = fs.readFileSync(controllerPath, 'utf8');
controllerCode = controllerCode.replace(/scanAndSave\(/g, 'scan(');
controllerCode = controllerCode.replace(/@Post\('scan-and-save'\)/g, "@Post('scan')");
fs.writeFileSync(controllerPath, controllerCode);

