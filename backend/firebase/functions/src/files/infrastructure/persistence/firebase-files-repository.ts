import * as admin from "firebase-admin";
import { FilesRepository } from "../../domain/ports/out/files-repository";
import { FileEntity } from "../../domain/models/file-entity";

export class FirebaseFilesRepository implements FilesRepository {
    private db = admin.database();

    async findExpiredFiles(): Promise<FileEntity[]> {
        const now = Date.now();
        const filesRef = this.db.ref('files');

        const snapshot = await filesRef
            .orderByChild('expiration_date')
            .once('value');

        const expiredFiles: FileEntity[] = [];

        snapshot.forEach((child) => {
            const file = child.val() as FileEntity;
            if (file.expiration_date < now) {
                file.uid = child.key as string;
                expiredFiles.push(file);
            }
            return false;
        });

        return expiredFiles;
    }

    async deleteFile(uid: string): Promise<void> {
        await this.db.ref(`files/${uid}`).remove();
    }
}