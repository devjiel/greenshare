import { FileEntity } from "../../models/file-entity";

export interface FilesRepository {
    findExpiredFiles(): Promise<FileEntity[]>;
    deleteFile(uid: string): Promise<void>;
}